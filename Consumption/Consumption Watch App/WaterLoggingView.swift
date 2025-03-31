//
//  WaterLoggingView.swift
//  Consumption
//
//  Created by Morris-Stiff R O (FCES) on 10/02/2025.
//

import SwiftUI
import WidgetKit

struct WaterLoggingView: View {
    
    @EnvironmentObject var consumptionModel: ConsumptionModel
    @Environment(\.presentationMode) var presentationMode

    @State private var waterInput: Int = 100

    var body: some View {
        VStack {
            // Stepper for water input
            Stepper(value: $waterInput, in: 100...1000, step: 100) {
                Text("Water: \(waterInput) mL")
                    .font(.body)
            }
            .padding()

            // Add Entry Button
            Button("Add Entry") {
                consumptionModel.resetDailyIfNeeded()
                consumptionModel.addWaterEntry(amount: waterInput)
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
    }
}
