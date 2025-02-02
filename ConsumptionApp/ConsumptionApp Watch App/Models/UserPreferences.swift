//
//  UserPreferences.swift
//  ConsumptionApp
//
//  Created by Morris-Stiff R O (FCES) on 02/02/2025.
//

import Foundation

struct UserPreferences: Codable {
    var waterTarget: Double      // User-defined daily water intake target in litres
    var remindersEnabled: Bool  // Whether the user wants drink reminders enabled
}
