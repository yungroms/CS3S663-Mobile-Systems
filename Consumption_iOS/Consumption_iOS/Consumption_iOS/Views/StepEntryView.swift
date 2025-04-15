//
//  StepEntryView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 13/04/2025.
//

import SwiftUI
import SwiftData

struct StepEntryView: View {
    @EnvironmentObject var viewModel: TrackerViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var stepInput: Int = 1000  // Default step count
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
                    // Display a mini steps trend chart. Assumes DailyStepsChartView exists.
                    DailyStepsChartView(dailyData: viewModel.getLast7DaysConsumption())
                        .transition(.opacity)
                } else {
                    Form {
                        Section(header: Label("Steps Count", systemImage: "figure.walk")) {
                            Stepper("\(stepInput) steps", value: $stepInput, in: 0...20000, step: 500)
                        }
                        
                        Section {
                            Button(action: {
                                withAnimation {
                                    viewModel.addStepEntry(steps: stepInput)
                                }
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Save Step Entry")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(BorderedProminentButtonStyle())
                        }
                    }
                }
            }
            .navigationTitle("Log Steps")
        }
    }
}
