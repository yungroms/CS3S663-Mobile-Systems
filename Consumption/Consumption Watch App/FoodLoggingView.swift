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
    @AppStorage("loggedFoods", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var loggedFoodsData: Data?

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
                addFoodLog(meal: selectedMeal, calories: calorieInput)  // Log the food
                saveCalories()  // Save updated calories to UserDefaults
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
        
        // Function to add a food log entry
        private func addFoodLog(meal: String, calories: Int) {
            let newFood = FoodItem(mealType: meal, calories: calories)
            
            // Fetch existing foods
            var foods = fetchLoggedFoods()
            
            // Add the new food log to the array
            foods.append(newFood)
            
            // Save updated foods array to UserDefaults
            saveLoggedFoods(foods)
            
            // Update daily calories total
            dailyCalories += calories
        }

        // Function to fetch all logged foods from UserDefaults
        private func fetchLoggedFoods() -> [FoodItem] {
            guard let data = loggedFoodsData else { return [] }
            let decoder = JSONDecoder()
            return (try? decoder.decode([FoodItem].self, from: data)) ?? []
        }

        // Function to save logged foods array to UserDefaults
        private func saveLoggedFoods(_ foods: [FoodItem]) {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(foods) {
                loggedFoodsData = encoded
            }
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
