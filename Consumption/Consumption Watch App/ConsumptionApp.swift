import SwiftUI
import UserNotifications

@main
struct Consumption_Watch_AppApp: App {
    // Use shared UserDefaults with the App Group
    @AppStorage("dailyCalories", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var dailyCalories: Int = 0
    @AppStorage("dailyWater", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var dailyWater: Int = 0
    @AppStorage("calorieGoal", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var calorieGoal: Int = 2000
    @AppStorage("waterGoal", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var waterGoal: Int = 2000
    @AppStorage("lastResetDate", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var lastResetDate: Date = Date()

    // Helper function to check if it's a new day
    func isNewDay(lastResetDate: Date) -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        
        // Extract just the year, month, and day from both dates
        let currentDay = calendar.startOfDay(for: currentDate)
        let lastResetDay = calendar.startOfDay(for: lastResetDate)
        
        return currentDay != lastResetDay
    }

    // Function to request notification permission
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            } else if success {
                print("Notification permission granted!")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    init() {
        // Check if it's a new day and reset values
        let currentDate = Date()
            let calendar = Calendar.current
            let lastResetDay = calendar.startOfDay(for: lastResetDate)
            let today = calendar.startOfDay(for: currentDate)

            if today != lastResetDay {
                dailyCalories = 0
                dailyWater = 0
                lastResetDate = currentDate
            
            // Explicitly save updated values to UserDefaults
            let sharedDefaults = UserDefaults(suiteName: "group.usw.rms.Consumption")
            sharedDefaults?.set(dailyCalories, forKey: "dailyCalories")
            sharedDefaults?.set(dailyWater, forKey: "dailyWater")
            sharedDefaults?.set(2000, forKey: "calorieGoal")
            sharedDefaults?.set(2000, forKey: "waterGoal")
            sharedDefaults?.set(lastResetDate, forKey: "lastResetDate")

            sharedDefaults?.synchronize() // Ensure values are saved immediately
        }

        // Request notification permission
        requestNotificationPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView() // Or any other root view you have
        }
    }
}
