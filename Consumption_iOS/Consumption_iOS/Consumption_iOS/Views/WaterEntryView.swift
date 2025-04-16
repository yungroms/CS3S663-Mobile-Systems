//
//  WaterEntryView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 13/04/2025.
//

import SwiftUI
import SwiftData

struct WaterEntryView: View {
    @EnvironmentObject var viewModel: TrackerViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var waterInput: Int = 100
    @State private var showChart: Bool = false
    
    // SwiftData aggregator records for the last 7 days
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
                Picker("Mode", selection: $showChart) {
                    Text("Log Entry").tag(false)
                    Text("View Trend").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if showChart {
                    // Show the water trend chart
                    DailyWaterChartView(dailyData: aggregatorRecords.sorted { $0.date < $1.date })
                        .transition(.opacity)
                } else {
                    Form {
                        Section(header: Label("Water Consumed", systemImage: "drop.fill")) {
                            Stepper("\(waterInput) mL", value: $waterInput, in: 100...5000, step: 100)
                        }
                        
                        Section {
                            Button(action: {
                                withAnimation {
                                    viewModel.addWaterEntry(amount: waterInput)
                                }
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Save Water Entry")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(BorderedProminentButtonStyle())
                        }
                    }
                }
            }
            .navigationTitle("Log Water")
        }
    }
}

