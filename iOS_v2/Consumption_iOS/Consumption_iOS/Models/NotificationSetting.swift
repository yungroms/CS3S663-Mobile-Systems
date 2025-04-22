//
//  NotificationSetting.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 18/04/2025.
//

import Foundation
import SwiftData

@Model
class NotificationSetting {
    var id: UUID = UUID()
    var breakfastTime: Date
    var lunchTime: Date
    var dinnerTime: Date

    init() {
        let calendar = Calendar.current
        self.breakfastTime = calendar.date(from: DateComponents(hour: 8, minute: 0)) ?? Date()
        self.lunchTime = calendar.date(from: DateComponents(hour: 12, minute: 0)) ?? Date()
        self.dinnerTime = calendar.date(from: DateComponents(hour: 18, minute: 0)) ?? Date()
    }
}
