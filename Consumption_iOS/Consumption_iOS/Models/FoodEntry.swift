//
//  FoodEntry.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftData
import Foundation

@Model
class FoodEntry {
    var id: UUID = UUID()
    var category: String
    var mealName: String
    var calories: Int
    var date: Date

    init() {
        self.category = "Breakfast"
        self.mealName = "Bacon & Eggs"
        self.calories = 450
        self.date = Calendar.current.startOfDay(for: Date())
    }
}

extension FoodEntry {
    static func todayPredicate() -> Predicate<FoodEntry> {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!

        return #Predicate<FoodEntry> { data in
            data.date >= startOfToday && data.date < startOfTomorrow
        }
    }
}
