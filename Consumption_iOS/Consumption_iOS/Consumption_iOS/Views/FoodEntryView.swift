//
//  FoodEntryView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 13/04/2025.
//

import SwiftUI

struct FoodEntryView: View {
    @EnvironmentObject var viewModel: TrackerViewModel
    @EnvironmentObject var categoryManager: MealCategoryManager
    @Environment(\.presentationMode) var presentationMode

    @State private var selectedMealType: String = "Breakfast"
    @State private var mealName: String = ""   // Custom meal name input
    @State private var calorieInput: Int = 100
    
    // Toggle for switching between Log Entry and Trend view
    @State private var showChart: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Picker("Mode", selection: $showChart) {
                    Text("Log Entry").tag(false)
                    Text("View Trend").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if showChart {
                    // Display a mini chart for food trends using DailyCaloriesChartView.
                    // Assumes DailyCaloriesChartView is available.
                    DailyCaloriesChartView(dailyData: viewModel.getLast7DaysConsumption())
                        .transition(.opacity)
                } else {
                    Form {
                        Section(header: Label("Meal Type", systemImage: "list.bullet")) {
                            // Use fixed meal categories from MealCategoryManager.
                            Picker("", selection: $selectedMealType) {
                                ForEach(categoryManager.categories, id: \.self) { meal in
                                    Text(meal)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        Section(header: Label("Meal Name", systemImage: "pencil")) {
                            TextField("e.g. Bacon & Eggs", text: $mealName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        Section(header: Label("Calories", systemImage: "flame.fill")) {
                            Stepper("\(calorieInput) kcal", value: $calorieInput, in: 50...2000, step: 50)
                        }
                        
                        Section {
                            Button(action: {
                                withAnimation {
                                    viewModel.addFoodEntry(category: selectedMealType, mealName: mealName, calories: calorieInput)
                                }
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Save Food Entry")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(BorderedProminentButtonStyle())
                        }
                    }
                }
            }
            .navigationTitle("Food Entry")
        }
    }
}
