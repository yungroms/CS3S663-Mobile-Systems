//
//  DailyConsumption.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 14/04/2025.
//

import Foundation
import SwiftData

@Model
class DailyConsumption {
    var id: UUID
    @Attribute(.unique) var date: Date
    var totalCalories: Int
    var totalWater: Int
    var totalSteps: Int
    
    init() {
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: Date())
        self.totalCalories = 0
        self.totalWater = 0
        self.totalSteps = 0
    }
}

extension DailyConsumption {
    static func todayPredicate() -> Predicate<DailyConsumption> {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!

        return #Predicate<DailyConsumption> { data in
            data.date >= startOfToday && data.date < startOfTomorrow
        }
    }
}
