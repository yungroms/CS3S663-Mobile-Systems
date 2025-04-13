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

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Water Consumed (mL)")) {
                    Stepper(value: $waterInput, in: 100...1000, step: 100) {
                        Text("\(waterInput) mL")
                    }
                }
                
                Section {
                    Button(action: {
                        viewModel.addWaterEntry(amount: Int(waterInput))
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save Water Entry")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
            }
            .navigationTitle("Log Water")
        }
    }
}
