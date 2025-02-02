//
//  UserPreferencesViewModel.swift
//  ConsumptionApp
//
//  Created by Morris-Stiff R O (FCES) on 02/02/2025.
//

import Foundation
import SwiftUI

class UserPreferencesViewModel: ObservableObject {
    @Published var preferences: UserPreferences

    init() {
        if let savedPreferences = DataManager.shared.loadPreferences() {
            preferences = savedPreferences
        } else {
            preferences = UserPreferences(waterTarget: 2.0, remindersEnabled: true)  // Default: 2L target, reminders on
        }
    }

    // Update water target
    func updateWaterTarget(to newTarget: Double) {
        preferences.waterTarget = newTarget
        savePreferences()
    }

    // Toggle reminders
    func toggleReminders() {
        preferences.remindersEnabled.toggle()
        savePreferences()
    }

    // Save preferences
    private func savePreferences() {
        DataManager.shared.savePreferences(preferences)
    }
}
