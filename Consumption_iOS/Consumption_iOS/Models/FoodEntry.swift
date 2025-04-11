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
    var calories: Int
    var date: Date

    init(category: String, calories: Int, date: Date = Date()) {
        self.category = category
        self.calories = calories
        self.date = date
    }
}
