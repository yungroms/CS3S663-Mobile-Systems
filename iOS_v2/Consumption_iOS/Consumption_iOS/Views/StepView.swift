//
//  StepEntryView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 13/04/2025.
//

import SwiftUI
import SwiftData
import WidgetKit

struct StepView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode

    @State private var todaySteps: Int = 0
    @State private var showChart: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    @Query private var aggregatorRecords: [DailyConsumption]

    var body: some View {
        VStack {
            Picker("Mode", selection: $showChart) {
                Text("Log").tag(false)
                Text("Chart").tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            if showChart {
                DailyStepsChartView(dailyData: aggregatorRecords.sorted { $0.date < $1.date })
                    .padding()
            } else {
                Form {
                    Section(header: Text("Today's Step Count")) {
                        Text("\(todaySteps) steps")
                            .font(.headline)

                        Button("Refresh Step Count") {
                            HealthKitManager.shared.fetchTodaySteps { steps, error in
                                DispatchQueue.main.async {
                                    if let steps = steps {
                                        self.todaySteps = Int(steps)
                                        print("Refreshed steps: \(steps)")

                                        let calendar = Calendar.current
                                        let startOfToday = calendar.startOfDay(for: Date())
                                        let endOfToday = calendar.date(byAdding: .day, value: 1, to: startOfToday)!

                                        let descriptor = FetchDescriptor<DailyConsumption>(
                                            predicate: #Predicate { record in
                                                record.date >= startOfToday && record.date < endOfToday
                                            }
                                        )

                                        do {
                                            let todayRecords = try modelContext.fetch(descriptor)
                                            if let todayRecord = todayRecords.first {
                                                todayRecord.totalSteps = Int(steps)
                                                try modelContext.save()
                                                WidgetCenter.shared.reloadAllTimelines()
                                                alertMessage = "Step count successfully refreshed and saved."
                                                showAlert = true
                                            } else {
                                                print("No DailyConsumption record found for today.")
                                            }
                                        } catch {
                                            print("Error saving steps to SwiftData: \(error)")
                                        }

                                    } else if let error = error {
                                        print("Error fetching steps: \(error)")
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
        .padding(.bottom)
        .navigationTitle("Steps")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            HealthKitManager.shared.fetchTodaySteps { steps, error in
                DispatchQueue.main.async {
                    if let steps = steps {
                        self.todaySteps = Int(steps)
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

