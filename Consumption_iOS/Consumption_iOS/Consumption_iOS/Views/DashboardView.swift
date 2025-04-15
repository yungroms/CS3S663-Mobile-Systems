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
        VStack(spacing: 10) {  // Reduced spacing from 20 to 10
            ZStack {
                // Outer Ring: Steps (Green) with original thickness (lineWidth: 12)
                Circle()
                    .trim(from: 0, to: progress(steps: totalSteps, target: targetStep))
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.green, .green.opacity(0.6)]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                    .shadow(radius: 4)
                    .animation(.easeInOut, value: viewModel.stepEntries)
                
                // Middle Ring: Food (Red) with original thickness (lineWidth: 12)
                Circle()
                    .trim(from: 0, to: progress(calories: totalCalories, target: targetCalorie))
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.red, .red.opacity(0.6)]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .shadow(radius: 4)
                    .animation(.easeInOut, value: viewModel.foodEntries)
                
                // Inner Ring: Water (Blue) with original thickness (lineWidth: 10)
                Circle()
                    .trim(from: 0, to: progress(water: totalWater, target: targetWater))
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .blue.opacity(0.6)]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                    .shadow(radius: 4)
                    .animation(.easeInOut, value: viewModel.waterEntries)
            }
            .padding(.horizontal) // Only horizontal padding, removing extra vertical space

            // Place the summary text below the rings
            VStack(spacing: 4) {
                Text("Food: \(totalCalories)/\(targetCalorie) kcal")
                    .font(.subheadline.bold())
                    .foregroundColor(.red)
                Text("Water: \(totalWater)/\(targetWater) mL")
                    .font(.subheadline.bold())
                    .foregroundColor(.blue)
                Text("Steps: \(totalSteps)/\(targetStep)")
                    .font(.subheadline.bold())
                    .foregroundColor(.green)
            }
            .padding(.top, 4)
            
            // NavigationLink to view detailed weekly trends.
            NavigationLink(destination: DailyCaloriesChartView(dailyData: viewModel.getLast7DaysConsumption())) {
                HStack {
                    Text("View Weekly Trends")
                        .font(.footnote.bold())
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)
            }
        }
    }
    
    // Computed totals
    private var totalCalories: Int {
        viewModel.foodEntries.reduce(0) { $0 + $1.calories }
    }
    private var totalWater: Int {
        viewModel.waterEntries.reduce(0) { $0 + $1.amount }
    }
    private var totalSteps: Int {
        viewModel.stepEntries.reduce(0) { $0 + $1.steps }
    }
    private var targetCalorie: Int {
        viewModel.currentTarget?.calorieTarget ?? 2000
    }
    private var targetWater: Int {
        viewModel.currentTarget?.waterTarget ?? 2000
    }
    private var targetStep: Int {
        viewModel.currentTarget?.stepTarget ?? 10000
    }
    
    // Progress functions (capped at 1.0)
    private func progress(calories: Int, target: Int) -> Double {
        min(Double(calories) / Double(target), 1.0)
    }
    private func progress(water: Int, target: Int) -> Double {
        min(Double(water) / Double(target), 1.0)
    }
    private func progress(steps: Int, target: Int) -> Double {
        min(Double(steps) / Double(target), 1.0)
    }
}
