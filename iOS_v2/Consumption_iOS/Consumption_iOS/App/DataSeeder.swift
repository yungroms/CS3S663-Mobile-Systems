//
//  DataSeeder.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 17/04/2025.
//

import Foundation
import SwiftData

@MainActor
struct DataSeeder {
    static func seedHistoryData(in context: ModelContext) {
        // Avoid duplicate seeding
        let fetchRequest = FetchDescriptor<DailyConsumption>()
        if let results = try? context.fetch(fetchRequest), results.count >= 30 {
            print("Historical data already seeded.")
            return
        }

        let today = Calendar.current.startOfDay(for: Date())
        let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"]

        for offset in 1...35 {
            guard let day = Calendar.current.date(byAdding: .day, value: -offset, to: today) else { continue }

            let calories = Int.random(in: 1400...2200)
            let waterML = Int.random(in: 1500...2500)
            let steps = Int.random(in: 3000...12000)

            // Insert DailyConsumption entry
            let entry = DailyConsumption()
            entry.date = day
            entry.totalCalories = calories
            entry.totalWater = waterML
            entry.totalSteps = steps
            context.insert(entry)

            // Insert meal entries for the same day
            for type in mealTypes {
                let mealCalories: Int
                switch type {
                case "Breakfast": mealCalories = Int.random(in: 300...500)
                case "Lunch":     mealCalories = Int.random(in: 500...700)
                case "Dinner":    mealCalories = Int.random(in: 500...800)
                case "Snack":     mealCalories = Int.random(in: 100...300)
                default:          mealCalories = 400
                }

                let meal = FoodEntry()
                meal.calories = mealCalories
                meal.date = day
                meal.category = type
                meal.mealName = type
                context.insert(meal)
            }
        }

        do {
            try context.save()
            print("✅ Historical data (with meal history) seeded.")
        } catch {
            print("❌ Error seeding historical data: \(error)")
        }
    }
}
