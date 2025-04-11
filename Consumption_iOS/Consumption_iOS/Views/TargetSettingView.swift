//
//  TargetSettingView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftUI

struct TargetSettingView: View {
    @EnvironmentObject var viewModel: TrackerViewModel
    @State private var calorieTarget: String = ""
    @State private var waterTarget: String = ""
    @State private var stepTarget: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Set Your Daily Targets")) {
                    TextField("Calorie Target", text: $calorieTarget)
                        .keyboardType(.numberPad)
                    TextField("Water Target (liters)", text: $waterTarget)
                        .keyboardType(.decimalPad)
                    TextField("Step Target", text: $stepTarget)
                        .keyboardType(.numberPad)
                }
                Button("Save Targets") {
                    if let cal = Int(calorieTarget),
                       let water = Double(waterTarget),
                       let steps = Int(stepTarget) {
                        viewModel.updateTarget(calorieTarget: cal, waterTarget: water, stepTarget: steps)
                        // Optionally, clear fields after saving.
                        calorieTarget = ""
                        waterTarget = ""
                        stepTarget = ""
                    }
                }
            }
            .navigationTitle("Targets")
        }
    }
}
