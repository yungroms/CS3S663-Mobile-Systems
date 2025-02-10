//
//  SettingsView.swift
//  Consumption
//
//  Created by Morris-Stiff R O (FCES) on 10/02/2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("calorieGoal") private var calorieGoal: Int = 2000
    @AppStorage("waterGoal") private var waterGoal: Double = 2.0

    var body: some View {
        VStack {
            Text("Set Your Daily Goals")
                .font(.headline)
                .padding(.bottom, 10)

            // Calorie Goal Section
            VStack {
                Stepper(value: $calorieGoal, in: 1000...4000, step: 100) {
                    Text("\(calorieGoal) kcal")
                        .font(.body) // Larger text for the value
                }
                .padding()

                Text("Calorie Goal")
                    .font(.subheadline)  // Smaller label text
                    .foregroundColor(.gray)  // To make the label less dominant
            }

            Divider()  // Separator between sections

            // Water Goal Section
            VStack {
                Stepper(value: $waterGoal, in: 0.5...4.0, step: 0.25) {
                    Text("\(waterGoal, specifier: "%.1f") L")
                        .font(.body)  // Larger text for the value
                }
                .padding()

                Text("Water Goal")
                    .font(.subheadline)  // Smaller label text
                    .foregroundColor(.gray)  // To make the label less dominant
            }

        }
        .navigationTitle("Settings")
        .padding()
    }
}
