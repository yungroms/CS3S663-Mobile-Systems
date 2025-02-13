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
    @AppStorage("lastUpdatedDate", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var lastUpdatedDate: String = ""

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
                resetIfNeeded()
                dailyCalories += calorieInput  // Update @AppStorage
                saveCalories()  // Explicitly save to shared UserDefaults
            }
            .padding()
        }
        //.navigationTitle("Log Food")
        //.padding()
    }

    private func saveCalories() {
        let sharedDefaults = UserDefaults(suiteName: "group.usw.rms.Consumption")
        sharedDefaults?.set(dailyCalories, forKey: "dailyCalories")
        sharedDefaults?.synchronize()  // Ensures changes persist

        print("Calories Saved to UserDefaults: \(sharedDefaults?.integer(forKey: "dailyCalories") ?? 0)")
        
        WidgetCenter.shared.reloadAllTimelines()  // Forces the widget to refresh
    }
    
    func resetIfNeeded() {
        let sharedDefaults = UserDefaults(suiteName: "group.usw.rms.Consumption")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Compare only the date, not time

        let today = formatter.string(from: Date())
        let lastDate = sharedDefaults?.string(forKey: "lastUpdatedDate") ?? ""

        if today != lastDate {
            print("New day detected. Resetting values.")
            sharedDefaults?.set(0, forKey: "dailyCalories")
            sharedDefaults?.set(0, forKey: "dailyWater")
            sharedDefaults?.set(today, forKey: "lastUpdatedDate")
            WidgetCenter.shared.reloadAllTimelines() // Ensure widget updates
        } else {
            print("Same day detected. No reset needed.")
        }
    }

}
