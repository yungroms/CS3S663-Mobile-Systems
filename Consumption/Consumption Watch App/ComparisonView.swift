//
//  ComparisonView.swift
//  Consumption
//
//  Created by Morris-Stiff R O (FCES) on 13/02/2025.
//

import SwiftUI

struct ComparisonView: View {
    @AppStorage("dailyCalories", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var dailyCalories: Int = 0
    @AppStorage("dailyWater", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var dailyWater: Int = 0
    @AppStorage("yesterdayCalories", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var yesterdayCalories: Int = 0
    @AppStorage("yesterdayWater", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var yesterdayWater: Int = 0
    @AppStorage("calorieGoal", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var calorieGoal: Int = 2000
    @AppStorage("waterGoal", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var waterGoal: Int = 2000
    
    var calorieProgressToday: Double {
        min(Double(dailyCalories) / Double(calorieGoal), 1.0)
    }
    
    var calorieProgressYesterday: Double {
        min(Double(yesterdayCalories) / Double(calorieGoal), 1.0)
    }
    
    var waterProgressToday: Double {
        min(Double(dailyWater) / Double(waterGoal), 1.0)
    }
    
    var waterProgressYesterday: Double {
        min(Double(yesterdayWater) / Double(waterGoal), 1.0)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Daily Comparison")
                .font(.headline)
            
            // Calorie Comparison
            VStack(alignment: .leading) {
                Text("Yesterday")
                    .font(.caption)
        
                ProgressView(value: calorieProgressYesterday, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .red))
                    .frame(height: 10)
                    .overlay(Text("\(yesterdayCalories) kcal").font(.caption).foregroundColor(.white), alignment: .trailing)
                
                ProgressView(value: waterProgressYesterday, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .frame(height: 10)
                    .overlay(Text("\(yesterdayWater) mL").font(.caption).foregroundColor(.white), alignment: .trailing)
            }
            
            // Water Comparison
            VStack(alignment: .leading) {
                Text("Today")
                    .font(.caption)
                
                ProgressView(value: calorieProgressToday, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .red))
                    .frame(height: 10)
                    .overlay(Text("\(dailyCalories) kcal").font(.caption).foregroundColor(.white), alignment: .trailing)
                
                ProgressView(value: waterProgressToday, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .frame(height: 10)
                    .overlay(Text("\(dailyWater) mL").font(.caption).foregroundColor(.white), alignment: .trailing)
            }
        }
        .padding()
    }
}
