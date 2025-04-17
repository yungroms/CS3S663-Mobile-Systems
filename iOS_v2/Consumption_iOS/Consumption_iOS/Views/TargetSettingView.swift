//
//  TargetSettingView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftUI
import WidgetKit

struct TargetSettingView: View {
    @EnvironmentObject var viewModel: TrackerViewModel
    
    @State private var calorieTarget: Int = 2000
    @State private var waterTarget: Int = 2000
    // Optionally, a step target:
    @State private var stepTarget: Int = 10000
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        Form {
            Section(header: Text("Calorie Goal")) {
                Stepper("\(calorieTarget) kcal", value: $calorieTarget, in: 1500...4000, step: 100)
            }
            
            Section(header: Text("Water Goal")) {
                Stepper("\(waterTarget) mL", value: $waterTarget, in: 1000...4000, step: 250)
            }
            
            Section(header: Text("Step Goal")) {
                Stepper("\(stepTarget) steps", value: $stepTarget, in: 0...30000, step: 500)
            }
            
            Button("Save Goals") {
                // Validate targets; show alert if invalid.
                if calorieTarget < 1500 || waterTarget < 1000 {
                    alertMessage = "Targets seem too low. Please set a realistic goal."
                    showAlert = true
                } else {
                    viewModel.updateTarget(calorieTarget: calorieTarget, waterTarget: waterTarget, stepTarget: stepTarget)
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
            .buttonStyle(BorderedButtonStyle())
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Target"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}
