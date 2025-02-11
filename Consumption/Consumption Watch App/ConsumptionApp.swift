import SwiftUI
import UserNotifications

@main
struct Consumption_Watch_AppApp: App {
    // Use shared UserDefaults with the App Group
    @AppStorage("dailyCalories", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var dailyCalories: Int = 0
    @AppStorage("dailyWater", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var dailyWater: Int = 0
    @AppStorage("calorieGoal", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var calorieGoal: Int = 2000
    @AppStorage("waterGoal", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var waterGoal: Int = 2000
    @AppStorage("lastResetDate", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var lastResetDate: Date = Date()

    // Helper function to check if it's a new day
    func isNewDay(lastResetDate: Date) -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        
        // Extract just the year, month, and day from both dates
        let currentDay = calendar.startOfDay(for: currentDate)
        let lastResetDay = calendar.startOfDay(for: lastResetDate)
        
        return currentDay != lastResetDay
    }

    // Function to request notification permission
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            } else if success {
                print("Notification permission granted!")
            } else {
                print("Notification permission denied.")
            }
        }
    }

    // Function to schedule reminders for meals
    func scheduleReminder(for meal: String, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Time to Log \(meal)"
        content.body = "Don't forget to log your \(meal) calories and water intake."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "\(meal)Reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling reminder for \(meal): \(error.localizedDescription)")
            } else {
                print("\(meal) reminder scheduled successfully.")
            }
        }
    }

    // Function to schedule daily reminders for food and water logging
    func scheduleDailyReminders() {
        // Schedule reminders for breakfast, lunch, and dinner
        scheduleReminder(for: "Breakfast", hour: 8, minute: 0)  // 8:00 AM
        scheduleReminder(for: "Lunch", hour: 12, minute: 0)     // 12:00 PM
        scheduleReminder(for: "Dinner", hour: 18, minute: 0)    // 6:00 PM
    }

    init() {
        // Check if it's a new day and reset values
        if isNewDay(lastResetDate: lastResetDate) {
            dailyCalories = 0
            dailyWater = 0
            
            // Update the last reset date to today
            lastResetDate = Date()
            
            // Explicitly save updated values to UserDefaults
            let sharedDefaults = UserDefaults(suiteName: "group.usw.rms.Consumption")
            sharedDefaults?.set(dailyCalories, forKey: "dailyCalories")
            sharedDefaults?.set(dailyWater, forKey: "dailyWater")
            sharedDefaults?.set(2000, forKey: "calorieGoal")
            sharedDefaults?.set(2000, forKey: "waterGoal")
            sharedDefaults?.synchronize() // Ensure values are saved immediately
        }

        // Request notification permission
        requestNotificationPermission()
        
        // Schedule daily reminders for food and water logging
        scheduleDailyReminders()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView() // Or any other root view you have
        }
    }
}
