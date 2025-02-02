//
//  Meal.swift
//  ConsumptionApp
//
//  Created by Morris-Stiff R O (FCES) on 02/02/2025.
//

import Foundation

struct Meal: Identifiable, Codable {
    var id: UUID = UUID()              // Unique identifier for each meal
    var category: String         // e.g., Breakfast, Snack, Lunch
    var calories: Int            // Number of calories in the meal
    var date: Date               // When the meal was logged
}
