//
//  DataManager.swift
//  ConsumptionApp
//
//  Created by Morris-Stiff R O (FCES) on 02/02/2025.
//

import Foundation

class DataManager {
    static let shared = DataManager()  // Singleton instance for easy access

    private let mealsKey = "meals"
    private let waterKey = "waterIntake"
    private let preferencesKey = "userPreferences"

    private init() {}  // Private initializer to prevent multiple instances

    // MARK: - Meal Persistence
    func saveMeals(_ meals: [Meal]) {
        if let encoded = try? JSONEncoder().encode(meals) {
            UserDefaults.standard.set(encoded, forKey: mealsKey)
        }
    }

    func loadMeals() -> [Meal] {
        if let data = UserDefaults.standard.data(forKey: mealsKey),
           let decoded = try? JSONDecoder().decode([Meal].self, from: data) {
            return decoded
        }
        return []  // Return an empty array if no data is found
    }

    // MARK: - Water Intake Persistence
    func saveWaterIntake(_ intake: WaterIntake) {
        if let encoded = try? JSONEncoder().encode(intake) {
            UserDefaults.standard.set(encoded, forKey: waterKey)
        }
    }

    func loadWaterIntake() -> WaterIntake? {
        if let data = UserDefaults.standard.data(forKey: waterKey),
           let decoded = try? JSONDecoder().decode(WaterIntake.self, from: data) {
            return decoded
        }
        return nil  // Return nil if no data is found
    }

    // MARK: - User Preferences Persistence
    func savePreferences(_ preferences: UserPreferences) {
        if let encoded = try? JSONEncoder().encode(preferences) {
            UserDefaults.standard.set(encoded, forKey: preferencesKey)
        }
    }

    func loadPreferences() -> UserPreferences? {
        if let data = UserDefaults.standard.data(forKey: preferencesKey),
           let decoded = try? JSONDecoder().decode(UserPreferences.self, from: data) {
            return decoded
        }
        return nil  // Return nil if no data is found
    }
}
