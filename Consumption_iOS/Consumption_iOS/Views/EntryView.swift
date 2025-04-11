//
//  EntryView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftUI

struct EntryView: View {
    @EnvironmentObject var viewModel: TrackerViewModel
    @State private var foodCategory: String = ""
    @State private var foodCalories: String = ""
    @State private var waterAmount: String = ""
    @State private var steps: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Food Entry")) {
                    TextField("Category", text: $foodCategory)
                    TextField("Calories", text: $foodCalories)
                        .keyboardType(.numberPad)
                    Button("Add Food Entry") {
                        if let calories = Int(foodCalories), !foodCategory.isEmpty {
                            viewModel.addFoodEntry(category: foodCategory, calories: calories)
                            foodCategory = ""
                            foodCalories = ""
                        }
                    }
                }
                Section(header: Text("Water Entry")) {
                    TextField("Amount (liters)", text: $waterAmount)
                        .keyboardType(.decimalPad)
                    Button("Add Water Entry") {
                        if let amount = Double(waterAmount) {
                            viewModel.addWaterEntry(amount: amount)
                            waterAmount = ""
                        }
                    }
                }
                Section(header: Text("Step Count Entry")) {
                    TextField("Steps", text: $steps)
                        .keyboardType(.numberPad)
                    Button("Add Step Entry") {
                        if let stepCount = Int(steps) {
                            viewModel.addStepEntry(steps: stepCount)
                            steps = ""
                        }
                    }
                }
            }
            .navigationTitle("Log Entry")
        }
    }
}
