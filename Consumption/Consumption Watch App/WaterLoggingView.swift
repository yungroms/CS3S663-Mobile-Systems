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
}
