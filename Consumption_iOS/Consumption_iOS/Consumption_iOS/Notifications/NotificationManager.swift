//
//  NotificationManager.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() { }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification authorization error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Schedules three meal reminders with the times specified.
    /// - Parameters:
    ///   - breakfastTime: DateComponents for breakfast notification (e.g. hour: 8, minute: 0).
    ///   - lunchTime: DateComponents for lunch notification (e.g. hour: 12, minute: 0).
    ///   - dinnerTime: DateComponents for dinner notification (e.g. hour: 18, minute: 0).
    func scheduleMealReminders(breakfastTime: DateComponents, lunchTime: DateComponents, dinnerTime: DateComponents) {
        let center = UNUserNotificationCenter.current()
        
        // Define your meal reminders as tuples: (Meal Name, Time Components, Message)
        let meals = [
            ("Breakfast", breakfastTime, "Time for breakfast!"),
            ("Lunch", lunchTime, "Time for lunch!"),
            ("Dinner", dinnerTime, "Time for dinner!")
        ]
        
        for meal in meals {
            let content = UNMutableNotificationContent()
            content.title = "FoodTracker Reminder - \(meal.0)"
            content.body = "Don't forget to log your \(meal.0.lowercased()) meal!"
            
            // Create a repeating calendar trigger using the provided time components.
            let trigger = UNCalendarNotificationTrigger(dateMatching: meal.1, repeats: true)
            
            let request = UNNotificationRequest(identifier: "MealReminder_\(meal.0)", content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling \(meal.0) reminder: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Optional default daily reminder.
    func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "FoodTracker Reminder"
        content.body = "Don't forget to log your food, water, and step entries for today."
        
        var dateComponents = DateComponents()
        dateComponents.hour = 20  // 8:00 PM reminder
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "DailyReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling daily reminder: \(error.localizedDescription)")
            }
        }
    }
}
