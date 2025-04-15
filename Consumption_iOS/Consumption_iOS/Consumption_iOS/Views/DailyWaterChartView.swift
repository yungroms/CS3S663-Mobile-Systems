//
//  DailyWaterChartView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 14/04/2025.
//

import SwiftUI
import Charts

struct DailyWaterChartView: View {
    let dailyData: [DailyConsumption]

    var body: some View {
        Chart(dailyData) { consumption in
            LineMark(
                x: .value("Date", consumption.date, unit: .day),
                y: .value("Water", consumption.totalWater)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .blue.opacity(0.6)]),
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
        .navigationTitle("Weekly Water")
    }
}

struct DailyWaterChartView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample data for preview (adapt as necessary)
        let sampleData = [
            DailyConsumption(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, totalCalories: 0, totalWater: 1500, totalSteps: 0),
            DailyConsumption(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, totalCalories: 0, totalWater: 1600, totalSteps: 0),
            DailyConsumption(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, totalCalories: 0, totalWater: 1400, totalSteps: 0),
            DailyConsumption(date: Date(), totalCalories: 0, totalWater: 1700, totalSteps: 0)
        ]
        NavigationView {
            DailyWaterChartView(dailyData: sampleData)
        }
    }
}
