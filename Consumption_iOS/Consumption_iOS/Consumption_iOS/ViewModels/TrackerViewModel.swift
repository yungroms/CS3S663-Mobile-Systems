//
//  TrackerViewModel.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftUI
import SwiftData

final class TrackerViewModel: ObservableObject {
    @Published var foodEntries: [FoodEntry] = []
    @Published var waterEntries: [WaterEntry] = []
    @Published var stepEntries: [StepCountEntry] = []
    @Published var currentTarget: Target?

    private var context: ModelContext

    init(context: ModelContext) {
        self.context = context
        loadPersistedData()
        print("ModelContext debug info: \(context)")
        debugPrint("ModelContext debug:", context)
    }
    
    func addFoodEntry(category: String, mealName: String, calories: Int) {
        let newEntry = FoodEntry(category: category, mealName: mealName, calories: calories)
        context.insert(newEntry)
        foodEntries.append(newEntry)
        save()
    }
    
    func addWaterEntry(amount: Int) {
        let newEntry = WaterEntry(amount: amount)
        context.insert(newEntry)
        waterEntries.append(newEntry)
        save()
    }
    
    func addStepEntry(steps: Int) {
        let newEntry = StepCountEntry(steps: steps)
        context.insert(newEntry)
        stepEntries.append(newEntry)
        save()
    }
    
    func updateTarget(calorieTarget: Int, waterTarget: Int, stepTarget: Int) {
        let newTarget = Target(calorieTarget: calorieTarget, waterTarget: waterTarget, stepTarget: stepTarget)
        context.insert(newTarget)
        currentTarget = newTarget
        save()
    }
    
    private func save() {
        do {
            try context.save()
            print("Data saved successfully. FoodEntries count: \(foodEntries.count)")
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    // MARK: - Data Fetching (Persistence)
    private func loadPersistedData() {
        do {
            // Fetch saved FoodEntry objects using an array of sort descriptors.
            let foodFetch: FetchDescriptor<FoodEntry> = FetchDescriptor(sortBy: [SortDescriptor(\.date)])
            let savedFood = try context.fetch(foodFetch)
            self.foodEntries = savedFood
            print("Fetched FoodEntries count: \(savedFood.count)")
            
            // Fetch saved WaterEntry objects.
            let waterFetch: FetchDescriptor<WaterEntry> = FetchDescriptor(sortBy: [SortDescriptor(\.date)])
            let savedWater = try context.fetch(waterFetch)
            self.waterEntries = savedWater
            print("Fetched WaterEntries count: \(savedWater.count)")
            
            // Fetch saved StepCountEntry objects.
            let stepsFetch: FetchDescriptor<StepCountEntry> = FetchDescriptor(sortBy: [SortDescriptor(\.date)])
            let savedSteps = try context.fetch(stepsFetch)
            self.stepEntries = savedSteps
            print("Fetched StepEntries count: \(savedSteps.count)")
            
            // Fetch saved Target objects and choose the most recent one.
            let targetFetch: FetchDescriptor<Target> = FetchDescriptor(sortBy: [SortDescriptor(\.date)])
            let savedTargets = try context.fetch(targetFetch)
            if let latest = savedTargets.sorted(by: { $0.date > $1.date }).first {
                self.currentTarget = latest
                print("Fetched current target: \(latest)")
            }
        } catch {
            print("Error loading persisted data: \(error)")
        }
    }
}

// MARK: - Daily Filtering and Grouping
extension TrackerViewModel {
    private var calendar: Calendar { Calendar.current }
    
    // Filter entries for today.
    var todaysFoodEntries: [FoodEntry] {
        let startOfDay = calendar.startOfDay(for: Date())
        return foodEntries.filter { $0.date >= startOfDay }
    }
    
    var todaysWaterEntries: [WaterEntry] {
        let startOfDay = calendar.startOfDay(for: Date())
        return waterEntries.filter { $0.date >= startOfDay }
    }
    
    var todaysStepEntries: [StepCountEntry] {
        let startOfDay = calendar.startOfDay(for: Date())
        return stepEntries.filter { $0.date >= startOfDay }
    }
    
    // Compute today's totals.
    var totalTodayCalories: Int {
        todaysFoodEntries.reduce(0) { $0 + $1.calories }
    }
    
    var totalTodayWater: Int {
        todaysWaterEntries.reduce(0) { $0 + $1.amount }
    }
    
    var totalTodaySteps: Int {
        todaysStepEntries.reduce(0) { $0 + $1.steps }
    }
    
    // Group food entries by day (using start of day as key).
    var foodEntriesByDay: [Date: [FoodEntry]] {
        Dictionary(grouping: foodEntries) { entry in
            calendar.startOfDay(for: entry.date)
        }
    }
    
    // Returns an array of daily summaries for the past 7 days.
    func getLast7DaysConsumption() -> [DailyConsumption] {
        let today = calendar.startOfDay(for: Date())
        var results: [DailyConsumption] = []
        
        for dayOffset in 0..<7 {
            guard let day = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            
            let foodForDay = foodEntries.filter { calendar.isDate($0.date, inSameDayAs: day) }
            let waterForDay = waterEntries.filter { calendar.isDate($0.date, inSameDayAs: day) }
            let stepsForDay = stepEntries.filter { calendar.isDate($0.date, inSameDayAs: day) }
            
            let calories = foodForDay.reduce(0) { $0 + $1.calories }
            let water = waterForDay.reduce(0) { $0 + $1.amount }
            let steps = stepsForDay.reduce(0) { $0 + $1.steps }
            
            let dailySummary = DailyConsumption(date: day,
                                                totalCalories: calories,
                                                totalWater: water,
                                                totalSteps: steps)
            results.append(dailySummary)
        }
        return results.sorted { $0.date < $1.date }
    }
}
