//
//  WaterIntake.swift
//  ConsumptionApp
//
//  Created by Morris-Stiff R O (FCES) on 02/02/2025.
//

import Foundation

struct WaterIntake: Codable {
    var date: Date              // Tracks the date of the water intake
    var consumedLitres: Double  // Amount of water consumed (in litres)
    var targetLitres: Double    // User's daily water consumption target
}
