//
//  WaterLoggingView.swift
//  Consumption
//
//  Created by Morris-Stiff R O (FCES) on 10/02/2025.
//

import SwiftUI
import WidgetKit

struct WaterLoggingView: View {
    @AppStorage("dailyWater", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var dailyWater: Int = 0
    @AppStorage("lastUpdatedDate", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var lastUpdatedDate: String = ""
    @State private var waterInput: Int = 100

    var body: some View {
        VStack {
            // Stepper for water input
            Stepper(value: $waterInput, in: 100...1000, step: 100) {
                Text("Water: \(waterInput) mL")
                    .font(.body)
            }
            .padding()

            // Add Entry Button
            Button("Add Entry") {
                resetIfNeeded()
                dailyWater += waterInput
                saveWater()
            }
            .padding()
        }
    }

    private func saveWater() {
        let sharedDefaults = UserDefaults(suiteName: "group.usw.rms.Consumption")
        sharedDefaults?.set(dailyWater, forKey: "dailyWater")
        sharedDefaults?.synchronize()  // Ensures changes persist

        print("Water Saved to UserDefaults: \(sharedDefaults?.double(forKey: "dailyWater") ?? 0)")
        
        WidgetCenter.shared.reloadAllTimelines()  // Forces the widget to refresh
    }
    
    func resetIfNeeded() {
        let sharedDefaults = UserDefaults(suiteName: "group.usw.rms.Consumption")
        let calendar = Calendar.current
        let lastResetDate = sharedDefaults?.object(forKey: "lastResetDate") as? Date ?? Date.distantPast
        let today = Date()

        if !calendar.isDate(lastResetDate, inSameDayAs: today) {
            print("Midnight Reset: Saving yesterday's data and resetting daily values")

            // Save yesterday's values
            let yesterdayCalories = sharedDefaults?.integer(forKey: "dailyCalories") ?? 0
            let yesterdayWater = sharedDefaults?.integer(forKey: "dailyWater") ?? 0
            sharedDefaults?.set(yesterdayCalories, forKey: "yesterdayCalories")
            sharedDefaults?.set(yesterdayWater, forKey: "yesterdayWater")

            // Reset today's values
            sharedDefaults?.set(0, forKey: "dailyCalories")
            sharedDefaults?.set(0, forKey: "dailyWater")
            sharedDefaults?.set(today, forKey: "lastResetDate")
            sharedDefaults?.synchronize()

            // Refresh the widget
            WidgetCenter.shared.reloadAllTimelines()
        } else {
            print("No reset needed: Already updated today.")
        }
    }
}
