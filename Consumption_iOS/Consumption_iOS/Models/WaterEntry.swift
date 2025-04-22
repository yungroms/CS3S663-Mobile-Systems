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

    init() {
        self.amount = 100
        self.date = Calendar.current.startOfDay(for: Date())
    }
}

extension WaterEntry {
    static func todayPredicate() -> Predicate<WaterEntry> {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!

        return #Predicate<WaterEntry> { data in
            data.date >= startOfToday && data.date < startOfTomorrow
        }
    }
}
