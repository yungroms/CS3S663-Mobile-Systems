import SwiftUI
import UserNotifications

@main
struct Consumption_Watch_AppApp: App {
    // Create your centralized model.
    @StateObject private var consumptionModel = ConsumptionModel()
    
    // Use init() only for tasks that don’t depend on view state.
    init() {
        // Request notification permission on launch.
        //consumptionModel.requestNotificationPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(consumptionModel)
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .onAppear {
                    // Reset values and schedule reminders when the app appears.
                    consumptionModel.requestNotificationPermission()
                    consumptionModel.resetDailyIfNeeded()
                    consumptionModel.scheduleDailyReminders()
                    consumptionModel.recalculateDailyTotals()
                }
        }
    }
}
