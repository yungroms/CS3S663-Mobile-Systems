//
//  ContentView.swift
//  ConsumptionApp Watch App
//
//  Created by Morris-Stiff R O (FCES) on 02/02/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var mealVM = MealViewModel()
    @StateObject private var waterVM = WaterIntakeViewModel()
    @StateObject private var preferencesVM = UserPreferencesViewModel()

    @State private var showAddMeal = false
    @State private var showSettings = false

    var body: some View {
        NavigationView {
            VStack {
                // Water Intake Progress
                VStack {
                    Text("Water Intake")
                        .font(.headline)
                    ProgressView(value: waterVM.waterIntake.consumedLitres, total: waterVM.waterIntake.targetLitres)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .padding()
                    Text("\(waterVM.waterIntake.consumedLitres, specifier: "%.1f")L / \(waterVM.waterIntake.targetLitres, specifier: "%.1f")L")
                        .font(.caption)
                    Button(action: { waterVM.addWater(amount: 0.25) }) {
                        Text("+250ml")
                            .padding(8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()

                Divider()

                // Meal List
                VStack {
                    Text("Meals & Snacks")
                        .font(.headline)
                    List {
                        ForEach(mealVM.meals) { meal in
                            VStack(alignment: .leading) {
                                Text(meal.category)
                                    .font(.headline)
                                Text("\(meal.calories) kcal")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .onDelete(perform: mealVM.deleteMeal)
                    }
                }

                Spacer()

                // Navigation Buttons
                HStack {
                    Button(action: { showAddMeal = true }) {
                        Label("Add Meal", systemImage: "plus")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: { showSettings = true }) {
                        Label("Settings", systemImage: "gear")
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .sheet(isPresented: $showAddMeal) {
                AddMealView(mealVM: mealVM)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(preferencesVM: preferencesVM, waterVM: waterVM)
            }
            .navigationTitle("Consumption Tracker")
        }
    }
}

#Preview {
    ContentView()
}
