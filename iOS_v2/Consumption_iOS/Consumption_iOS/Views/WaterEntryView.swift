//
//  WaterEntryView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 13/04/2025.
//

import SwiftUI
import SwiftData

struct WaterEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode

    @State private var waterAmount: Int = 250
    @State private var showChart = false

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
            sort: \DailyConsumption.date,
            order: .forward
        )
    }

    var body: some View {
        VStack {
            Text("Water Entry")
                .font(.title2)
                .bold()
                .padding(.top)

            Picker("Mode", selection: $showChart) {
                Text("Log Entry").tag(false)
                Text("View Trend").tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if showChart {
                DailyWaterChartView(dailyData: aggregatorRecords.sorted { $0.date < $1.date })
            } else {
                Form {
                    Section(header: Text("Amount (ml)")) {
                        Stepper("\(waterAmount) ml", value: $waterAmount, in: 50...2000, step: 50)
                    }

                    Section {
                        Button("Save Water Entry") {
                            viewModel.addWaterEntry(amount: waterAmount)
                            presentationMode.wrappedValue.dismiss()
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
        .padding(.bottom)
    }
}
