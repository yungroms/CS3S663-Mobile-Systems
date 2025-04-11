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
        // Optionally, load existing entries here.
    }
    
    func addFoodEntry(category: String, calories: Int) {
        let newEntry = FoodEntry(category: category, calories: calories)
        context.insert(newEntry)
        foodEntries.append(newEntry)
        save()
    }
    
    func addWaterEntry(amount: Double) {
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
    
    func updateTarget(calorieTarget: Int, waterTarget: Double, stepTarget: Int) {
        let newTarget = Target(calorieTarget: calorieTarget, waterTarget: waterTarget, stepTarget: stepTarget)
        context.insert(newTarget)
        currentTarget = newTarget
        save()
    }
    
    private func save() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

