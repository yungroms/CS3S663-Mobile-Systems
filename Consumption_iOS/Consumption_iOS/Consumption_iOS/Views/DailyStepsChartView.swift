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
        Chart(dailyData.sorted(by: { $0.date < $1.date })) { consumption in
            BarMark(
                x: .value("Date", consumption.date, unit: .day),
                y: .value("Steps", consumption.totalSteps)
            )
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [.green, .green.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .padding()
        .navigationTitle("Weekly Steps")
    }
}
