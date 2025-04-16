//
//  TrackerViewModel.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftUI
import SwiftData

final class TrackerViewModel: ObservableObject {
    /// We no longer store arrays of FoodEntry, WaterEntry, or StepCountEntry,
    /// because SwiftData @Query or manual fetch calls handle reading data in the UI.
    @Published var currentTarget: Target?

    private var context: ModelContext

    init(context: ModelContext) {
        self.context = context
        print("ModelContext debug info: \(context)")
        debugPrint("ModelContext debug:", context)
        // We do NOT fetch arrays here. The UI uses SwiftData queries for that.
    }
    
    // MARK: - Add Methods
    
    func addFoodEntry(category: String, mealName: String, calories: Int) {
        let newEntry = FoodEntry()
        newEntry.category = category
        newEntry.mealName = mealName
        newEntry.calories = calories
        // If you want to store precise time, use Date()
        // If you want day-level, use startOfDay:
        newEntry.date = Date()

        context.insert(newEntry)
        
        // Optional aggregator update
        let dailyRecord = fetchOrCreateDailyConsumption(for: Date())
        dailyRecord.totalCalories += calories

        save()
    }

    func addWaterEntry(amount: Int) {
        let newEntry = WaterEntry()
        newEntry.amount = amount
        newEntry.date = Date()

        context.insert(newEntry)
        
        let dailyRecord = fetchOrCreateDailyConsumption(for: Date())
        dailyRecord.totalWater += amount

        save()
    }

    func addStepEntry(steps: Int) {
        let newEntry = StepCountEntry()
        newEntry.steps = steps
        newEntry.date = Date()

        context.insert(newEntry)

        let dailyRecord = fetchOrCreateDailyConsumption(for: Date())
        dailyRecord.totalSteps += steps

        save()
    }
    
    // MARK: - Target Methods
    
    func updateTarget(calorieTarget: Int, waterTarget: Int, stepTarget: Int) {
        // If you need only one Target per day, you could either fetch or create
        // today’s target record. For example:
        let newTarget = Target()
        newTarget.calorieTarget = calorieTarget
        newTarget.waterTarget = waterTarget
        newTarget.stepTarget = stepTarget
        // By default, 'newTarget.date' is set to startOfDay, or you can set a custom date.
        
        context.insert(newTarget)
        currentTarget = newTarget
        save()
    }

    // MARK: - Daily Aggregator Helper
    
    private func fetchOrCreateDailyConsumption(for date: Date) -> DailyConsumption {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let startOfTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

        let descriptor = FetchDescriptor<DailyConsumption>(
            predicate: #Predicate { $0.date >= startOfDay && $0.date < startOfTomorrow }
        )

        // Attempt to find today's record
        let existingRecord = try? context.fetch(descriptor).first
        if let daily = existingRecord {
            return daily
        } else {
            let newAggregator = DailyConsumption()
            newAggregator.date = startOfDay
            context.insert(newAggregator)
            return newAggregator
        }
    }

    // MARK: - Save
    
    private func save() {
        do {
            try context.save()
            print("Data saved successfully.")
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
