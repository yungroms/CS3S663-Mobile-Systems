//
//  DailyStepsChartView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 14/04/2025.
//

import SwiftUI
import Charts

struct DailyStepsChartView: View {
    let dailyData: [DailyConsumption]

    var body: some View {
        Chart(dailyData) { consumption in
            LineMark(
                x: .value("Date", consumption.date, unit: .day),
                y: .value("Steps", consumption.totalSteps)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [.green, .green.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .symbol(Circle())
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .padding()
        .navigationTitle("Weekly Steps")
    }
}

struct DailyStepsChartView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample data for preview (adapt as necessary)
        let sampleData = [
            DailyConsumption(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, totalCalories: 0, totalWater: 0, totalSteps: 9000),
            DailyConsumption(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, totalCalories: 0, totalWater: 0, totalSteps: 11000),
            DailyConsumption(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, totalCalories: 0, totalWater: 0, totalSteps: 9500),
            DailyConsumption(date: Date(), totalCalories: 0, totalWater: 0, totalSteps: 12000)
        ]
        NavigationView {
            DailyStepsChartView(dailyData: sampleData)
        }
    }
}
