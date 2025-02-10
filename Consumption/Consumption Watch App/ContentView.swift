//
//  ContentView.swift
//  Consumption
//
//  Created by Morris-Stiff R O (FCES) on 10/02/2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("dailyCalories", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var dailyCalories: Int = 0
    @AppStorage("dailyWater", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var dailyWater: Double = 0.0
    @AppStorage("calorieGoal") private var calorieGoal: Int = 2000
    @AppStorage("waterGoal") private var waterGoal: Double = 2.0

    // Force view to refresh when values change
    @State private var calorieProgress: Double = 0.0
    @State private var waterProgress: Double = 0.0

    var body: some View {
        NavigationView {
            VStack {
                // Overlapping Rings (ZStack)
                ZStack {
                    // Outer Ring (Calories - Red)
                    Circle()
                        .trim(from: 0.0, to: CGFloat(calorieProgress))
                        .stroke(Color.red, lineWidth: 12)
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))

                    // Inner Ring (Water - Blue)
                    Circle()
                        .trim(from: 0.0, to: CGFloat(waterProgress))
                        .stroke(Color.blue, lineWidth: 8)
                        .frame(width: 90, height: 90)
                        .rotationEffect(.degrees(-90))

                    // Center Text Overlay
                    VStack {
                        Text("\(dailyCalories)/\(calorieGoal) kcal")
                            .font(.footnote)
                            .foregroundColor(.red)
                        Text("\(dailyWater, specifier: "%.1f")/\(waterGoal, specifier: "%.1f") L")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                }
                .padding()

                // Buttons for Logging
                HStack {
                    NavigationLink(destination: FoodLoggingView()) {
                        Text("Log Food")
                    }
                    .buttonStyle(BorderedButtonStyle())

                    NavigationLink(destination: WaterLoggingView()) {
                        Text("Log Water")
                    }
                    .buttonStyle(BorderedButtonStyle())
                }

                // Settings Link
                NavigationLink("Settings", destination: SettingsView())
            }
            .navigationTitle("Daily Tracker")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                updateProgress()
            }
            .onChange(of: dailyCalories) { _, _ in updateProgress() } // Updated syntax for watchOS 10
            .onChange(of: dailyWater) { _, _ in updateProgress() } // Updated syntax for watchOS 10
        }
    }

    private func updateProgress() {
        calorieProgress = min(Double(dailyCalories) / Double(calorieGoal), 1.0)
        waterProgress = min(dailyWater / waterGoal, 1.0)
    }
}
