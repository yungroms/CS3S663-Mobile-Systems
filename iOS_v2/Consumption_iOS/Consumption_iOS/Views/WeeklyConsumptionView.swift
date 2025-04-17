//
//  WeeklyConsumptionView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 16/04/2025.
//

import SwiftUI
import SwiftData

struct WeeklyConsumptionView: View {
    // 1) We define the current date range for the last 7 days
    private var sevenDaysAgo: Date {
        Calendar.current.date(byAdding: .day, value: -6, to: Calendar.current.startOfDay(for: Date()))!
    }
    private var tomorrow: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))!
    }
    private var thirtyDaysAgo: Date {
        Calendar.current.date(byAdding: .day, value: -29, to: Calendar.current.startOfDay(for: Date()))!
    }
    
    // 2) Use a @Query to fetch DailyConsumption in that date range
    @Query private var aggregatorRecords: [DailyConsumption]
    
    init() {
        // We create a custom predicate that includes all aggregator records from `sevenDaysAgo` up to "tomorrow".
        // This ensures we have the last 7 start-of-day slices + today.
        let predicate: Predicate<DailyConsumption> = #Predicate { record in
            record.date >= sevenDaysAgo && record.date < tomorrow
        }
        _aggregatorRecords = Query(
            filter: predicate,
            sort: \DailyConsumption.date,
            order: .forward
        )
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // 3) Pass aggregatorRecords to your existing chart views
                // They each require `dailyData: [DailyConsumption]`.
                
                // Example for calories
                DailyCaloriesChartView(dailyData: aggregatorRecords)
                
                // Example for water
                DailyWaterChartView(dailyData: aggregatorRecords)
                
                // Example for steps
                DailyStepsChartView(dailyData: aggregatorRecords)
            }
            .navigationTitle("Weekly Overview")
        }
    }
}
