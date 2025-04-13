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
        VStack {
            ZStack {
                // Outer Ring: Steps (Green)
                Circle()
                    .trim(from: 0, to: CGFloat(min(Double(viewModel.stepEntries.reduce(0) { $0 + $1.steps }) / Double(viewModel.currentTarget?.stepTarget ?? 10000), 1.0)))
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                
                // Middle Ring: Food (Red)
                Circle()
                    .trim(from: 0, to: CGFloat(min(Double(viewModel.foodEntries.reduce(0) { $0 + $1.calories }) / Double(viewModel.currentTarget?.calorieTarget ?? 2000), 1.0)))
                    .stroke(Color.red, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                
                // Inner Ring: Water (Blue)
                Circle()
                    .trim(from: 0, to: CGFloat(min(Double(viewModel.waterEntries.reduce(0) { $0 + $1.amount }) / Double(viewModel.currentTarget?.waterTarget ?? 2000), 1.0)))
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                
                // Centered Stats Text
                VStack(spacing: 2) {
                    Text("Food: \(viewModel.foodEntries.reduce(0){ $0 + $1.calories })/\(viewModel.currentTarget?.calorieTarget ?? 2000) kcal")
                        .font(.caption)
                        .foregroundColor(.red)
                    Text("Water: \(viewModel.waterEntries.reduce(0){ $0 + $1.amount })/\(viewModel.currentTarget?.waterTarget ?? 2000) mL")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Text("Steps: \(viewModel.stepEntries.reduce(0){ $0 + $1.steps })/\(viewModel.currentTarget?.stepTarget ?? 10000)")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            .padding()
            // Optionally, add additional UI elements (buttons, more stats)
        }
    }
}
