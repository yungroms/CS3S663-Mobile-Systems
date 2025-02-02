//
//  MealViewModel.swift
//  ConsumptionApp
//
//  Created by Morris-Stiff R O (FCES) on 02/02/2025.
//

import Foundation

class MealViewModel: ObservableObject {
    @Published var meals: [Meal] {
        didSet {
            saveMeals()
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "meals"),
           let decodedMeals = try? JSONDecoder().decode([Meal].self, from: data) {
            self.meals = decodedMeals
        } else {
            self.meals = []
        }
    }
    
    func addMeal(_ meal: Meal) {
        meals.append(meal)
    }
    
    func resetMeals() {
        meals = []
    }
    
    private func saveMeals() {
        if let encoded = try? JSONEncoder().encode(meals) {
            UserDefaults.standard.set(encoded, forKey: "meals")
        }
    }
}

