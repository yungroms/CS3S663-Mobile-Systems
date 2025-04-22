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
    @Attribute(.unique) var date: Date

    init() {
        self.calorieTarget = 2000
        self.waterTarget = 2000
        self.stepTarget = 10000
        self.date = Calendar.current.startOfDay(for: Date())
    }
}

extension Target {
    static func todayPredicate() -> Predicate<Target> {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!

        return #Predicate<Target> { data in
            data.date >= startOfToday && data.date < startOfTomorrow
        }
    }
}
