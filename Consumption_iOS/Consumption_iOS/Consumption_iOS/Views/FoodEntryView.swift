//
//  FoodEntryView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 13/04/2025.
//

import SwiftUI
import SwiftData

struct FoodEntryView: View {
    @EnvironmentObject var viewModel: TrackerViewModel
    @EnvironmentObject var categoryManager: MealCategoryManager
    @Environment(\.presentationMode) var presentationMode

    @State private var selectedMealType: String = "Breakfast"
    @State private var mealName: String = ""
    @State private var calorieInput: Int = 100
    
    // Toggle for switching between Log Entry and Trend view
    @State private var showChart: Bool = false

    // 1) Add a SwiftData Query for the last 7 days of aggregator records
    @Query private var aggregatorRecords: [DailyConsumption]
    
    init() {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        // 7 days back from today
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -6, to: startOfToday)!
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!
        
        // Custom predicate: aggregator must be in [sevenDaysAgo ..< tomorrow]
        let predicate: Predicate<DailyConsumption> = #Predicate { record in
            record.date >= sevenDaysAgo && record.date < tomorrow
        }
        
        // Sort ascending by date
        _aggregatorRecords = Query(
            filter: predicate,
            sort: \DailyConsumption.date,
            order: .forward
        )
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Toggle: Log Entry vs. View Trend
                Picker("Mode", selection: $showChart) {
                    Text("Log Entry").tag(false)
                    Text("View Trend").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if showChart {
                    // 2) Display a mini chart for food trends using DailyCaloriesChartView
                    //    but now passing aggregatorRecords from SwiftData
                    DailyCaloriesChartView(dailyData: aggregatorRecords.sorted(by: { $0.date < $1.date }))
                        .transition(.opacity)

                } else {
                    // 3) The "Log Entry" form
                    Form {
                        Section(header: Label("Meal Type", systemImage: "list.bullet")) {
                            Picker("", selection: $selectedMealType) {
                                ForEach(categoryManager.categories, id: \.self) { meal in
                                    Text(meal)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        Section(header: Label("Meal Name", systemImage: "pencil")) {
                            TextField("e.g. Takoyaki", text: $mealName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        Section(header: Label("Calories", systemImage: "flame.fill")) {
                            Stepper("\(calorieInput) kcal", value: $calorieInput, in: 50...2000, step: 50)
                        }
                        
                        Section {
                            Button(action: {
                                withAnimation {
                                    viewModel.addFoodEntry(
                                        category: selectedMealType,
                                        mealName: mealName,
                                        calories: calorieInput
                                    )
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
