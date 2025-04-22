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
    @Query private var last7Days: [DailyConsumption]
    @Query private var weeklyTargets: [Target]

    init() {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let weekAgo = calendar.date(byAdding: .day, value: -6, to: startOfToday)!

        let dcPredicate: Predicate<DailyConsumption> = #Predicate { $0.date >= weekAgo }
        _last7Days = Query(filter: dcPredicate, sort: \.date, order: .forward)

        let tPredicate: Predicate<Target> = #Predicate { $0.date >= weekAgo }
        _weeklyTargets = Query(filter: tPredicate, sort: \.date, order: .forward)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("7-Day Overview")
                .font(.headline)
                .padding(.horizontal)

            Chart {
                ForEach(last7Days, id: \.self) { record in
                    let date = record.date
                    let target = weeklyTargets.first { Calendar.current.isDate($0.date, inSameDayAs: date) }

                    let calorieProgress = normalized(value: record.totalCalories, goal: target?.calorieTarget ?? 2000)
                    let waterProgress = normalized(value: record.totalWater, goal: target?.waterTarget ?? 2000)
                    let stepProgress = normalized(value: record.totalSteps, goal: target?.stepTarget ?? 10000)

                    BarMark(
                        x: .value("Date", date, unit: .day),
                        y: .value("Progress", calorieProgress)
                    )
                    .foregroundStyle(Color.red.opacity(0.8))
                    .position(by: .value("Metric", "Calories"))

                    BarMark(
                        x: .value("Date", date, unit: .day),
                        y: .value("Progress", waterProgress)
                    )
                    .foregroundStyle(Color.blue.opacity(0.8))
                    .position(by: .value("Metric", "Water"))

                    BarMark(
                        x: .value("Date", date, unit: .day),
                        y: .value("Progress", stepProgress)
                    )
                    .foregroundStyle(Color.green.opacity(0.8))
                    .position(by: .value("Metric", "Steps"))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) {
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                    }
            }
            .frame(height: 240)
            .padding(.horizontal)
        }
        .padding(.vertical)
    }

    private func normalized(value: Int, goal: Int) -> Double {
        guard goal > 0 else { return 0.0 }
        return min(Double(value) / Double(goal), 1.0)
    }
}
