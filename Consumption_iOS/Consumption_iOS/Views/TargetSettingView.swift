//
//  TargetSettingView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftUI
import WidgetKit  // Added import for WidgetKit

struct TargetSettingView: View {
    @EnvironmentObject var viewModel: TrackerViewModel
    
    @State private var calorieTarget: Int = 2000
    @State private var waterTarget: Int = 2000
    
    var body: some View {
        Form {
            Section(header: Text("Calorie Goal")) {
                Stepper("\(calorieTarget) kcal", value: $calorieTarget, in: 1500...4000, step: 100)
            }
            
            Section(header: Text("Water Goal")) {
                Stepper("\(Int(waterTarget)) mL", value: $waterTarget, in: 1000...4000, step: 250)
            }
            
            Button("Save Goals") {
                viewModel.updateTarget(calorieTarget: calorieTarget, waterTarget: waterTarget, stepTarget: 0) // adjust for steps if available
                WidgetCenter.shared.reloadAllTimelines()  // Now available with WidgetKit imported
            }
            .buttonStyle(BorderedButtonStyle())
        }
    }
}
