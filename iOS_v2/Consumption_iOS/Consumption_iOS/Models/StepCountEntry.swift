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

    init() {
        self.steps = 1000
        self.date = Calendar.current.startOfDay(for: Date())
    }
}

extension StepCountEntry {
    static func todayPredicate() -> Predicate<StepCountEntry> {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!

        return #Predicate<StepCountEntry> { data in
            data.date >= startOfToday && data.date < startOfTomorrow
        }
    }
}

