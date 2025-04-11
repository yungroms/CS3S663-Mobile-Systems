//
//  WaterEntry.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftData
import Foundation

@Model
class WaterEntry {
    var id: UUID = UUID()
    var amount: Double  // e.g., in liters
    var date: Date

    init(amount: Double, date: Date = Date()) {
        self.amount = amount
        self.date = date
    }
}
