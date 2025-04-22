//
//  WaterEntryView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 13/04/2025.
//

import SwiftUI
import SwiftData
import WidgetKit

struct WaterView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab: Int = 0
    @State private var waterAmount: Int = 250
    
    @State private var showSaveAlert = false
    @State private var alertMessage = ""

    @Query private var dailyData: [DailyConsumption]

    var body: some View {
        VStack {
            
            Picker("Mode", selection: $selectedTab) {
                Text("Log").tag(0)
                Text("Chart").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            if selectedTab == 0 {
                Form {
                    Section(header: Text("Amount")) {
                        Stepper("\(waterAmount) ml", value: $waterAmount, in: 100...2000, step: 50)
                    }

                    Section {
                        Button("Save Water Entry") {
                            let entry = WaterEntry()
                            entry.amount = waterAmount
                            entry.date = Date()

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

                                aggregator.totalWater += waterAmount

                                try modelContext.save()
                                waterAmount = 250
                                alertMessage = "Water entry saved."
                                showSaveAlert = true
                                WidgetCenter.shared.reloadAllTimelines()
                                
                            } catch {
                                print("Failed to save water entry or aggregator: \(error.localizedDescription)")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.borderedProminent)
                    }
                }
            } else if selectedTab == 1 {
                DailyWaterChartView(dailyData: dailyData.sorted { $0.date < $1.date })
                    .padding()
            }
        }
        .alert(isPresented: $showSaveAlert) {
            Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("Water")
        .navigationBarTitleDisplayMode(.inline)
    }
}
