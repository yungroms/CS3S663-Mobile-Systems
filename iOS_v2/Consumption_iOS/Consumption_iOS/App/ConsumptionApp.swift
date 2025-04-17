//
//  ConsumptionApp.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct FoodTrackerApp: App {
    
    let consumptionContainer: ModelContainer
    
    init() {
        let schema = Schema([FoodEntry.self, WaterEntry.self, StepCountEntry.self, Target.self, DailyConsumption.self])
        let config = ModelConfiguration(schema: schema, url: URL.applicationSupportDirectory.appending(path: "ConsumptionApp.db"))
        
        do {
            consumptionContainer = try ModelContainer(for: schema, configurations: config)

               } catch {
                   fatalError("Could not configure container.")
               }
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(consumptionContainer)
                .environmentObject(MealCategoryManager())
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
                    NotificationManager.shared.scheduleDailyReminder()

//                    Task {
//                        DataSeeder.seedHistoryData(in: consumptionContainer.mainContext)
//                    }
                }
        }
        //.modelContainer(consumptionContainer)
    }
}
