//
//  StepEntryView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 13/04/2025.
//

import SwiftUI
import SwiftData

struct StepEntryView: View {
    @Environment(\.modelContext) private var context
    @State private var currentSteps: Int = 0
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
            Text("Steps")
                .font(.title2)
                .bold()
                .padding(.top)

            Picker("Mode", selection: $showChart) {
                Text("Today Steps").tag(false)
                Text("View Trend").tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if showChart {
                DailyStepsChartView(dailyData: aggregatorRecords.sorted { $0.date < $1.date })
            } else {
                VStack(spacing: 20) {
                    Text("Today's Steps")
                        .font(.headline)

                    Text("\(currentSteps)")
                        .font(.largeTitle.bold())

                    Button("Refresh Steps") {
                        fetchTodayStepsAndUpdateAggregator()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .onAppear {
            requestHealthKitAuth()
            fetchTodayStepsAndUpdateAggregator()
        }
        .padding(.bottom)
    }

    private func requestHealthKitAuth() {
        HealthKitManager.shared.requestAuthorization { success, error in
            if !success {
                print("HealthKit auth failed: \(String(describing: error))")
            }
        }
    }

    private func fetchTodayStepsAndUpdateAggregator() {
        HealthKitManager.shared.fetchTodaySteps { steps, error in
            DispatchQueue.main.async {
                guard let steps = steps else { return }
                self.currentSteps = Int(steps)
                updateAggregatorWithSteps(Int(steps))
            }
        }
    }

    private func updateAggregatorWithSteps(_ steps: Int) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let descriptor = FetchDescriptor<DailyConsumption>(
            predicate: #Predicate {
                $0.date >= startOfDay && $0.date < startOfTomorrow
            }
        )

        do {
            if let existingRecord = try context.fetch(descriptor).first {
                existingRecord.totalSteps = steps
            } else {
                let newRecord = DailyConsumption()
                newRecord.date = startOfDay
                newRecord.totalSteps = steps
                context.insert(newRecord)
            }
            try context.save()
        } catch {
            print("Error saving steps to aggregator: \(error)")
        }
    }
}

