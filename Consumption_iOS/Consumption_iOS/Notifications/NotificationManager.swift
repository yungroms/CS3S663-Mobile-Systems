//
//  NotificationManager.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import UserNotifications
import Foundation

class NotificationManager {
    static let shared = NotificationManager()

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied or error: \(error?.localizedDescription ?? "unknown")")
            }
        }
    }

    func scheduleMealReminders(
        breakfastTime: DateComponents,
        lunchTime: DateComponents,
        dinnerTime: DateComponents
    ) {
        scheduleReminder(identifier: "breakfastReminder", title: "Don't forget breakfast!", hour: breakfastTime.hour ?? 8, minute: breakfastTime.minute ?? 0)
        scheduleReminder(identifier: "lunchReminder", title: "It's lunchtime!", hour: lunchTime.hour ?? 12, minute: lunchTime.minute ?? 0)
        scheduleReminder(identifier: "dinnerReminder", title: "Time for dinner!", hour: dinnerTime.hour ?? 18, minute: dinnerTime.minute ?? 0)
    }


    private func scheduleReminder(identifier: String, title: String, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "Log your meal in the Consumption app."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule \(identifier): \(error.localizedDescription)")
            } else {
                print("Scheduled: \(identifier) at \(hour):\(String(format: "%02d", minute))")
            }
        }
    }
}
