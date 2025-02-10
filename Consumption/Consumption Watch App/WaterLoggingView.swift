//
//  WaterLoggingView.swift
//  Consumption
//
//  Created by Morris-Stiff R O (FCES) on 10/02/2025.
//

import SwiftUI
import WidgetKit

struct WaterLoggingView: View {
    @AppStorage("dailyWater", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var dailyWater: Double = 0.0
    @State private var waterInput: Double = 0.1 

    var body: some View {
        VStack {
            // Stepper for water input
            Stepper(value: $waterInput, in: 0.1...1.0, step: 0.1) {
                Text("Water: \(waterInput, specifier: "%.1f") L")
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
        .navigationTitle("Log Water")
        .padding()
    }

    private func saveWater() {
        let sharedDefaults = UserDefaults(suiteName: "group.usw.rms.Consumption")
        sharedDefaults?.set(dailyWater, forKey: "dailyWater")
        sharedDefaults?.synchronize()  // Ensures changes persist

        print("Water Saved to UserDefaults: \(sharedDefaults?.double(forKey: "dailyWater") ?? 0.0)")
        
        WidgetCenter.shared.reloadAllTimelines()  // Forces the widget to refresh
    }
}
