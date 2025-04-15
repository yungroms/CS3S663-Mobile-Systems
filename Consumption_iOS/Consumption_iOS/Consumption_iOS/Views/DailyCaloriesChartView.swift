//
//  DailyCaloriesChartView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 14/04/2025.
//

import SwiftUI
import Charts

struct DailyCaloriesChartView: View {
    let dailyData: [DailyConsumption]

    var body: some View {
        Chart {
            ForEach(dailyData) { consumption in
                LineMark(
                    x: .value("Date", consumption.date, unit: .day),
                    y: .value("Calories", consumption.totalCalories)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(.red)
                .symbol(Circle())
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .padding()
        .navigationTitle("Weekly Calories")
    }
}

struct DailyCaloriesChartView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample data for preview
        let sampleData = [
            DailyConsumption(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, totalCalories: 1800, totalWater: 1500, totalSteps: 9000),
            DailyConsumption(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, totalCalories: 2000, totalWater: 1600, totalSteps: 11000),
            DailyConsumption(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, totalCalories: 2200, totalWater: 1400, totalSteps: 9500),
            DailyConsumption(date: Date(), totalCalories: 2100, totalWater: 1700, totalSteps: 12000)
        ]
        NavigationView {
            DailyCaloriesChartView(dailyData: sampleData)
        }
    }
}
