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
struct ConsumptionApp: App {
    
    let consumptionContainer: ModelContainer
    
    init() {
        let schema = Schema([
            FoodEntry.self,
            WaterEntry.self,
            StepCountEntry.self,
            Target.self,
            DailyConsumption.self,
            NotificationSetting.self
        ])

        let sharedURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.usw.consumption")!
        let dbURL = sharedURL.appendingPathComponent("consumption.db")

        let config = ModelConfiguration(schema: schema, url: dbURL)

        do {
            let fileExists = FileManager.default.fileExists(atPath: dbURL.path)

            consumptionContainer = try ModelContainer(for: schema, configurations: config)

            print("SwiftData store location: \(dbURL.path)")
            if fileExists {
                print("Database file confirmed at \(dbURL.path)")
            } else {
                print("Database file did not exist. A new one was created.")
            }

        } catch {
            print("Failed to initialize SwiftData store or fetch required tables.")
            print("Error: \(error.localizedDescription)")
            print("Possible causes: missing tables (e.g., ZWATERENTRY), schema mismatch, corrupted store.")
            fatalError("Could not configure container: \(error.localizedDescription)")
        }
    }


    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(consumptionContainer)
                .environmentObject(MealCategoryManager())
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
//                    Task {
//                        DataSeeder.seedHistoryData(in: consumptionContainer.mainContext)
//                    }
                    if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.usw.consumption") {
                        print("App Group Container Path: \(containerURL.path)")
                    } else {
                        print("Failed to locate App Group container")
                    }
                    HealthKitManager.shared.requestAuthorization { success, error in
                        if success {
                            print("HealthKit authorized")
                        } else if let error = error {
                            print("HealthKit authorization error: \(error.localizedDescription)")
                        }
                    }
                }
        }
    }
    
    private func seedDefaultNotifications(in context: ModelContext) {
        let existing = try? context.fetch(FetchDescriptor<NotificationSetting>())
        guard (existing?.isEmpty ?? true) else { return }

        let setting = NotificationSetting()
        context.insert(setting)
        try? context.save()
    }

}
