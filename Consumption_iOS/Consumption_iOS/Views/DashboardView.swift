//
//  DashboardView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var viewModel: TrackerViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Dashboard")
                .font(.largeTitle)
            Text("Food entries: \(viewModel.foodEntries.count)")
            Text("Water entries: \(viewModel.waterEntries.count)")
            Text("Step entries: \(viewModel.stepEntries.count)")
            
            if let target = viewModel.currentTarget {
                VStack {
                    Text("Daily Targets:")
                        .font(.headline)
                    Text("Calories: \(target.calorieTarget)")
                    Text("Water: \(target.waterTarget, specifier: "%.2f") L")
                    Text("Steps: \(target.stepTarget)")
                }
            } else {
                Text("No targets set")
            }
            
            Spacer()
        }
        .padding()
    }
}
