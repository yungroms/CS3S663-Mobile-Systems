//
//  FoodItem.swift
//  Consumption
//
//  Created by Morris-Stiff R O (FCES) on 13/02/2025.
//

import Foundation

struct FoodItem: Identifiable, Codable {
    var id: UUID
    var mealType: String // Breakfast, Lunch, Dinner, etc.
    var calories: Int

    init(mealType: String, calories: Int) {
        self.id = UUID()
        self.mealType = mealType
        self.calories = calories
    }
}
