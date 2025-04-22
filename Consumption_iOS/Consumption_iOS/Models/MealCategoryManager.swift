//
//  MealCategoryManager.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 14/04/2025.
//

import SwiftUI
import Combine

final class MealCategoryManager: ObservableObject {
    @Published var categories: [String] = ["Breakfast", "Lunch", "Dinner", "Snack"]
    
    func addCategory(_ category: String) {
        if !categories.contains(category) {
            categories.append(category)
        }
    }
}
