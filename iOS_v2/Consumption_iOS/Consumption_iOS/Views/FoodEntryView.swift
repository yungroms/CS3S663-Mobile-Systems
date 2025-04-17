//
//  FoodEntryView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 13/04/2025.
//

import SwiftUI
import SwiftData

struct FoodEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var categoryManager: MealCategoryManager
    @Environment(\.presentationMode) var presentationMode

    @State private var selectedMealType: String = "Breakfast"
    @State private var mealName: String = ""
    @State private var calorieInput: Int = 100
    @State private var showChart: Bool = false

    @Query private var aggregatorRecords: [DailyConsumption]

    init() {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -6, to: startOfToday)!
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!

        let predicate: Predicate<DailyConsumption> = #Predicate { record in
            record.date >= sevenDaysAgo && record.date < tomorrow
        }

        _aggregatorRecords = Query(
            filter: predicate,
            sort: \.date,
            order: .forward
        )
    }

    var body: some View {
        VStack {
            Text("Food Entry")
                .font(.title2)
                .bold()
                .padding(.top)

            Picker("Mode", selection: $showChart) {
                Text("Log Entry").tag(false)
                Text("View Trend").tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            @ViewBuilder
            var content: some View {
                if showChart {
                    DailyCaloriesChartView(dailyData: aggregatorRecords.sorted { $0.date < $1.date })
                        .transition(.opacity)
                } else {
                    Form {
                        Section(header: Text("Meal Type")) {
                            Picker("Meal Type", selection: $selectedMealType) {
                                ForEach(categoryManager.categories, id: \.self) { meal in
                                    Text(meal)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }

                        Section(header: Text("Meal Name")) {
                            TextField("e.g. Takoyaki", text: $mealName)
                        }

                        Section(header: Text("Calories")) {
                            Stepper("\(calorieInput) kcal", value: $calorieInput, in: 50...2000, step: 50)
                        }

                        Section {
                            Button("Save Food Entry") {
                                withAnimation {
                                    let newEntry = FoodEntry(
                                        name: mealName,
                                        calories: calorieInput,
                                        date: .now,
                                        category: selectedMealType
                                    )

                                    modelContext.insert(newEntry)

                                    do {
                                        try modelContext.save()
                                        print("✅ Food entry saved.")
                                        presentationMode.wrappedValue.dismiss()
                                    } catch {
                                        print("❌ Error saving food entry: \(error.localizedDescription)")
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }

            content
        }
        .padding(.bottom)
    }
}
