//
//  StepCountEntry.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftData
import Foundation

@Model
class StepCountEntry {
    var id: UUID = UUID()
    var steps: Int
    var date: Date

    init(steps: Int, date: Date = Date()) {
        self.steps = steps
        self.date = date
    }
}
