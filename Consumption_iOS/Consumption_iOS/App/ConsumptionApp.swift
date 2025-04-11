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
            ContentViewWrapper()  // Our new wrapper view handles context injection.
                .onAppear {
                    // Request notification permissions when the app starts.
                    NotificationManager.shared.requestAuthorization()
                    NotificationManager.shared.scheduleDailyReminder()
                }
        }
        // Attach a model container for your data models.
        .modelContainer(for: [FoodEntry.self, WaterEntry.self, StepCountEntry.self, Target.self])
    }
}

