//
//  DailyConsumption.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 14/04/2025.
//

import Foundation

struct DailyConsumption: Identifiable {
    let id = UUID()
    let date: Date
    let totalCalories: Int
    let totalWater: Int
    let totalSteps: Int
}
