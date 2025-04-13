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
    var body: some Scene {
        WindowGroup {
            // Use the wrapper to inject the TrackerViewModel with the model context.
            ContentViewWrapper()
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
                    NotificationManager.shared.scheduleDailyReminder()
                }
        }
        .modelContainer(for: [FoodEntry.self, WaterEntry.self, StepCountEntry.self, Target.self])
    }
}
