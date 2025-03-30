import SwiftUI
import UserNotifications
import CoreData
import WidgetKit

class ConsumptionModel: ObservableObject {
    // Published properties for daily totals, reset date, yesterday's values, and the consumption goals.
    @Published var dailyCalories: Int = 0
    @Published var dailyWater: Int = 0
    @Published var lastResetDate: Date = Date()  // This holds the date of the last reset.
    @Published var yesterdayCalories: Int = 0
    @Published var yesterdayWater: Int = 0
    @Published var calorieGoal: Int = 2000
    @Published var waterGoal: Int = 2000
    @Published var foodLogs: [FoodItem] = []
    
    init() {
        loadConsumptionSettings()
    }
    
    /// Resets daily values if a new day has begun.
    func resetDailyIfNeeded() {
        let calendar = Calendar.current
        let currentDate = Date()
        let today = calendar.startOfDay(for: currentDate)
        let lastResetDay = calendar.startOfDay(for: lastResetDate)
        
        if today != lastResetDay {
            // Save yesterday's values.
            yesterdayCalories = dailyCalories
            yesterdayWater = dailyWater
            
            // Reset today's totals.
            dailyCalories = 0
            dailyWater = 0
            lastResetDate = currentDate
            
            print("Daily values reset. Yesterday's totals: \(yesterdayCalories) cals, \(yesterdayWater) mL water")
        }
    }
    
    /// Schedules reminders for meals.
    func scheduleDailyReminders() {
        scheduleReminder(for: "Breakfast", hour: 8, minute: 0)
        scheduleReminder(for: "Lunch", hour: 12, minute: 0)
        scheduleReminder(for: "Dinner", hour: 18, minute: 0)
    }
    
    /// Helper to schedule a reminder for a specific meal.
    private func scheduleReminder(for meal: String, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Time to Log \(meal)"
        content.body = "Remember to log your \(meal) calories and water intake."
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
    
    /// Requests notification permission.
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else if granted {
                print("Notification permission granted!")
            } else {
                print("Notification permission denied.")
            }
        }
    }
        
    /// Adds a food log by increasing the daily calorie count.
    func addFoodLog(meal: String, calories: Int) {
        let context = PersistenceController.shared.container.viewContext
        let newEntry = FoodEntry(context: context)
        newEntry.id = UUID()
        newEntry.mealType = meal
        newEntry.calories = Int16(calories)
        newEntry.date = Date()
        
        do {
            try context.save()
            print("Saved food entry: \(meal), \(calories) kcal")
            recalculateDailyTotals()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("Failed to save food entry: \(error.localizedDescription)")
        }
    }

    /// Adds water to the daily total.
    func addWaterEntry(amount: Int) {
        let context = PersistenceController.shared.container.viewContext
        let newEntry = WaterEntry(context: context)
        newEntry.id = UUID()
        newEntry.amount = Int16(amount)
        newEntry.date = Date()
        
        do {
            try context.save()
            print("Saved water entry: \(amount) mL")
            recalculateDailyTotals()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("Failed to save water entry: \(error.localizedDescription)")
        }
    }
    
    func recalculateDailyTotals() {
        let context = PersistenceController.shared.container.viewContext
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // Fetch FoodEntry objects for today.
        let foodRequest: NSFetchRequest<FoodEntry> = FoodEntry.fetchRequest()
        foodRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        
        // Fetch WaterEntry objects for today.
        let waterRequest: NSFetchRequest<WaterEntry> = WaterEntry.fetchRequest()
        waterRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        
        do {
            let foodEntries = try context.fetch(foodRequest)
            let totalCalories = foodEntries.reduce(0) { $0 + Int($1.calories) }
            
            let waterEntries = try context.fetch(waterRequest)
            let totalWater = waterEntries.reduce(0) { $0 + Int($1.amount) }
            
            DispatchQueue.main.async {
                self.dailyCalories = totalCalories
                self.dailyWater = totalWater
            }
        } catch {
            print("Error recalculating daily totals: \(error.localizedDescription)")
        }
    }
    
    func updateAppSettings(calorieGoal: Int, waterGoal: Int) {
        let context = PersistenceController.shared.container.viewContext
        // Try to fetch an existing AppSettings record.
        let request: NSFetchRequest<ConsumptionSettings> = ConsumptionSettings.fetchRequest()
        do {
            let results = try context.fetch(request)
            let settings: ConsumptionSettings
            if let existing = results.first {
                settings = existing
            } else {
                settings = ConsumptionSettings(context: context)
                settings.id = UUID() // if you have an id attribute
            }
            settings.calorieGoal = Int16(calorieGoal)
            settings.waterGoal = Int16(waterGoal)
            try context.save()
            print("App settings updated.")
        } catch {
            print("Error updating app settings: \(error.localizedDescription)")
        }
    }
    
    func fetchAppSettings() -> (calorieGoal: Int, waterGoal: Int) {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<ConsumptionSettings> = ConsumptionSettings.fetchRequest()
        do {
            let results = try context.fetch(request)
            if let settings = results.first {
                return (calorieGoal: Int(settings.calorieGoal), waterGoal: Int(settings.waterGoal))
            }
        } catch {
            print("Error fetching app settings: \(error.localizedDescription)")
        }
        // Return default values if not found.
        return (calorieGoal: 2000, waterGoal: 2000)
    }
    
    func loadConsumptionSettings() {
        let settings = fetchAppSettings()
        DispatchQueue.main.async {
            self.calorieGoal = settings.calorieGoal
            self.waterGoal = settings.waterGoal
        }
        print("Loaded settings: calorieGoal = \(settings.calorieGoal), waterGoal = \(settings.waterGoal)")
    }
}
