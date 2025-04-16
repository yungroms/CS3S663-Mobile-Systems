//
//  StepEntryView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 13/04/2025.
//

import SwiftUI
import SwiftData

struct StepEntryView: View {
    // No manual step entry. We'll fetch from HealthKit instead.
    
    // If you still rely on some parts of the old tracker logic, keep this environment object.
    // Otherwise, you can remove it if it's not needed.
    @EnvironmentObject var viewModel: TrackerViewModel
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.modelContext) private var context  // Use the SwiftData context directly
    
    // Toggle between showing today's steps vs. bar chart
    @State private var showChart: Bool = false
    
    // We'll store the user’s daily steps from HealthKit
    @State private var currentSteps: Int = 0

    // SwiftData aggregator for last 7 days, to show in a bar chart
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
        NavigationView {
            VStack {
                // Picker for toggling between "Today's Steps" and "Weekly Trend" chart
                Picker("Mode", selection: $showChart) {
                    Text("Today Steps").tag(false)
                    Text("View Trend").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if showChart {
                    // Show a bar chart for daily steps aggregator
                    DailyStepsChartView(dailyData: aggregatorRecords.sorted { $0.date < $1.date })
                        .transition(.opacity)
                } else {
                    // Show the user’s step count from HealthKit
                    VStack(spacing: 20) {
                        Text("Today's Steps")
                            .font(.headline)
                        
                        Text("\(currentSteps)")
                            .font(.largeTitle.bold())
                        
                        // A button to manually refresh data from HealthKit
                        // (in case the user wants an updated reading)
                        Button("Refresh Steps") {
                            fetchTodayStepsAndUpdateAggregator()
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 10)
                    }
                }
            }
            .navigationTitle("Steps")
            .onAppear {
                requestHealthKitAuth()
                // Fetch steps & update aggregator once on appear
                fetchTodayStepsAndUpdateAggregator()
            }
        }
    }
    
    // MARK: - HealthKit Access

    private func requestHealthKitAuth() {
        HealthKitManager.shared.requestAuthorization { success, error in
            if success {
                print("HealthKit authorized for steps")
            } else {
                print("HealthKit auth failed: \(String(describing: error))")
            }
        }
    }

    private func fetchTodayStepsAndUpdateAggregator() {
        HealthKitManager.shared.fetchTodaySteps { steps, error in
            DispatchQueue.main.async {
                guard let steps = steps else {
                    print("Error fetching steps: \(String(describing: error))")
                    return
                }
                // Update our local display variable
                self.currentSteps = Int(steps)
                // Optionally store in aggregator
                updateAggregatorWithSteps(Int(steps))
            }
        }
    }
    
    // MARK: - Aggregator

    private func updateAggregatorWithSteps(_ steps: Int) {
        // 1) Determine today's aggregator date range
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let descriptor = FetchDescriptor<DailyConsumption>(
            predicate: #Predicate {
                $0.date >= startOfDay && $0.date < startOfTomorrow
            }
        )

        do {
            // 2) Attempt to find today's aggregator
            if let existingRecord = try context.fetch(descriptor).first {
                // Update total steps
                existingRecord.totalSteps = steps
            } else {
                // No record found; create a new aggregator
                let newAgg = DailyConsumption()
                newAgg.date = startOfDay
                newAgg.totalSteps = steps
                context.insert(newAgg)
            }
            // 3) Save changes
            try context.save()
            print("Updated aggregator with \(steps) steps for today.")
        } catch {
            print("Error updating aggregator with steps: \(error)")
        }
    }
}
