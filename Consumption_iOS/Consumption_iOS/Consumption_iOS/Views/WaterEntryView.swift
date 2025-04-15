//
//  WaterEntryView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 13/04/2025.
//

import SwiftUI

struct WaterEntryView: View {
    @EnvironmentObject var viewModel: TrackerViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var waterInput: Int = 250  // Default value in mL
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
                    // Display a mini water trend chart. Assumes DailyWaterChartView exists.
                    DailyWaterChartView(dailyData: viewModel.getLast7DaysConsumption())
                        .transition(.opacity)
                } else {
                    Form {
                        Section(header: Label("Water Consumed", systemImage: "drop.fill")) {
                            Stepper("\(waterInput) mL", value: $waterInput, in: 100...1000, step: 100)
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
