//
//  FoodLoggingView.swift
//  Consumption
//
//  Created by Morris-Stiff R O (FCES) on 10/02/2025.
//

import SwiftUI
import WidgetKit

struct FoodLoggingView: View {
    @AppStorage("dailyCalories", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var dailyCalories: Int = 0
    @State private var selectedMeal = "Breakfast"
    @State private var calorieInput = 100  // Default calorie input

    let mealOptions = ["Breakfast", "Lunch", "Dinner", "Snack"]

    var body: some View {
        VStack {
            // Meal Selection Picker
            Picker("Meal Type", selection: $selectedMeal) {
                ForEach(mealOptions, id: \.self) { meal in
                    Text(meal)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 70)

            // Stepper for calorie input
            Stepper(value: $calorieInput, in: 50...2000, step: 50) {
                Text("Cals: \(calorieInput)")
                    .font(.body)
            }
            .padding()

            // Add Entry Button
            Button("Add Entry") {
                dailyCalories += calorieInput  // Update @AppStorage
                saveCalories()  // Explicitly save to shared UserDefaults
            }
            .padding()
        }
        .navigationTitle("Log Food")
        .padding()
    }

    private func saveCalories() {
        let sharedDefaults = UserDefaults(suiteName: "group.usw.rms.Consumption")
        sharedDefaults?.set(dailyCalories, forKey: "dailyCalories")
        sharedDefaults?.synchronize()  // Ensures changes persist

        print("Calories Saved to UserDefaults: \(sharedDefaults?.integer(forKey: "dailyCalories") ?? 0)")
        
        WidgetCenter.shared.reloadAllTimelines()  // Forces the widget to refresh
    }
}
