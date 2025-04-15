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
    var amount: Int
    var date: Date

    init(amount: Int, date: Date = Date()) {
        self.amount = amount
        self.date = date
    }
}
