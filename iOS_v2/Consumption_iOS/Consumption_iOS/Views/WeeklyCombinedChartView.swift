//
//  WeeklyCombinedChartView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 17/04/2025.
//

import SwiftUI
import SwiftData
import Charts

struct WeeklyCombinedChartView: View {
    @Environment(\.calendar) private var calendar

    // Automatically pulls all DailyConsumption entries and sorts them by date
    @Query(sort: [SortDescriptor(\DailyConsumption.date)]) var allEntries: [DailyConsumption]

    // Filters the entries to just the last 7 days
    private var last7Days: [DailyConsumption] {
        let today = calendar.startOfDay(for: Date())
        guard let sevenDaysAgo = calendar.date(byAdding: .day, value: -6, to: today) else {
            return []
        }
        return allEntries.filter { $0.date >= sevenDaysAgo && $0.date <= today }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("7-Day Progress Overview")
                .font(.headline)
                .padding(.horizontal)

            Text("🔍 \(last7Days.count) entries found") // Debug message

            if last7Days.isEmpty {
                Text("No data available.")
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                Chart {
                    ForEach(last7Days, id: \.self) { entry in
                        BarMark(
                            x: .value("Date", entry.date, unit: .day),
                            y: .value("Calories", entry.totalCalories)
                        )
                        .foregroundStyle(Color.red.opacity(0.7))

                        BarMark(
                            x: .value("Date", entry.date, unit: .day),
                            y: .value("Water", entry.totalWater)
                        )
                        .foregroundStyle(Color.blue.opacity(0.7))

                        BarMark(
                            x: .value("Date", entry.date, unit: .day),
                            y: .value("Steps", entry.totalSteps)
                        )
                        .foregroundStyle(Color.green.opacity(0.7))
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 240)
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}
