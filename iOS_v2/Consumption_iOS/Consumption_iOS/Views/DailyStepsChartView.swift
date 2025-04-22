//
//  DailyStepsChartView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 14/04/2025.
//

import SwiftUI
import Charts
import SwiftData

struct DailyStepsChartView: View {
    let dailyData: [DailyConsumption]

    var body: some View {
        let startDate = Calendar.current.date(byAdding: .day, value: -27, to: Date())!
        let filteredData = dailyData
            .filter { $0.date >= startDate }
            .sorted { $0.date < $1.date }

        Chart(filteredData) { entry in
            BarMark(
                x: .value("Date", entry.date, unit: .day),
                y: .value("Steps", entry.totalSteps)
            )
            .foregroundStyle(.green)
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.day().month(.abbreviated), centered: true)
            }
        }
        .chartPlotStyle { plotArea in
            plotArea
                .frame(minHeight: 250)
                .padding(.horizontal, 10)
        }
        .frame(height: 300)
    }
}
