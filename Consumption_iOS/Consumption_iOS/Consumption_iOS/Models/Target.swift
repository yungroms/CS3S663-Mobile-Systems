//
//  Target.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftData
import Foundation

@Model
class Target {
    var id: UUID = UUID()
    var calorieTarget: Int
    var waterTarget: Int
    var stepTarget: Int
    var date: Date

    init(calorieTarget: Int, waterTarget: Int, stepTarget: Int, date: Date = Date()) {
        self.calorieTarget = calorieTarget
        self.waterTarget = waterTarget
        self.stepTarget = stepTarget
        self.date = date
    }
}
