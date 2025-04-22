//
//  FoodEntryView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 13/04/2025.
//

import SwiftUI
import SwiftData
import WidgetKit

struct FoodView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var categoryManager: MealCategoryManager
    @Environment(\.presentationMode) var presentationMode

    @State private var selectedMealType: String = "Breakfast"
    @State private var mealName: String = ""
    @State private var calorieInput: Int = 100
    @State private var selectedTab: Int = 0
    @State private var showSaveAlert: Bool = false

    @Query private var aggregatorRecords: [DailyConsumption]
    @Query private var entries: [FoodEntry]

    var body: some View {
        VStack {

            Picker("Mode", selection: $selectedTab) {
                Text("Log").tag(0)
                Text("Chart").tag(1)
                Text("History").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            if selectedTab == 0 {
                Form {
                    Section(header: Text("Meal Type")) {
                        Picker("", selection: $selectedMealType) {
                            ForEach(categoryManager.categories, id: \.self) { meal in
                                Text(meal)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }

                    Section(header: Text("Meal Name")) {
                        TextField("e.g. Bacon & Eggs", text: $mealName)
                    }

                    Section(header: Text("Calories")) {
                        Stepper("\(calorieInput) kcal", value: $calorieInput, in: 50...2000, step: 50)
                    }

                    Section {
                        Button("Save Food Entry") {
                            let entry = FoodEntry()
                            entry.mealName = mealName
                            entry.calories = calorieInput
                            entry.date = Date()
                            entry.category = selectedMealType

                            modelContext.insert(entry)

                            let calendar = Calendar.current
                            let startOfToday = calendar.startOfDay(for: Date())
                            let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!

                            let predicate = #Predicate<DailyConsumption> {
                                $0.date >= startOfToday && $0.date < startOfTomorrow
                            }

                            let fetch = FetchDescriptor<DailyConsumption>(predicate: predicate)

                            do {
                                let matching = try modelContext.fetch(fetch)
                                let aggregator = matching.first ?? DailyConsumption()
                                if matching.isEmpty {
                                    aggregator.date = startOfToday
                                    modelContext.insert(aggregator)
                                }

                                aggregator.totalCalories += calorieInput

                                try modelContext.save()
                                calorieInput = 100
                                mealName = ""
                                showSaveAlert = true
                                WidgetCenter.shared.reloadAllTimelines()

                            } catch {
                                print("Failed to save food entry or aggregator: \(error.localizedDescription)")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.borderedProminent)
                    }
                }
            } else if selectedTab == 1 {
                DailyCaloriesChartView(dailyData: aggregatorRecords.sorted { $0.date < $1.date })
                    .padding()
            } else if selectedTab == 2 {
                List {
                    let grouped = Dictionary(grouping: entries) { entry in
                        Calendar.current.startOfDay(for: entry.date)
                    }

                    let sortedDates = grouped.keys.sorted(by: >)

                    ForEach(sortedDates, id: \.self) { date in
                        Section(header: Text(date.formatted(date: .abbreviated, time: .omitted))) {
                            ForEach(grouped[date] ?? []) { entry in
                                Text("\(entry.category) - \(entry.mealName) - \(entry.calories) kcal")
                            }
                        }
                    }
                }
            }
        }
        .padding(.bottom)
        .navigationTitle("Food")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showSaveAlert) {
            Alert(title: Text("Food Entry Saved"), dismissButton: .default(Text("OK")))
        }
    }
}
