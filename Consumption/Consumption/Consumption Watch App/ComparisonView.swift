//
//  ComparisonView.swift
//  Consumption
//
//  Created by Morris-Stiff R O (FCES) on 13/02/2025.
//

import SwiftUI

struct ComparisonView: View {
    
    @EnvironmentObject var consumptionModel: ConsumptionModel

    
    var calorieProgressToday: Double {
        min(Double(consumptionModel.dailyCalories) / Double(consumptionModel.calorieGoal), 1.0)
    }
    
    var calorieProgressYesterday: Double {
        min(Double(consumptionModel.yesterdayCalories) / Double(consumptionModel.calorieGoal), 1.0)
    }
    
    var waterProgressToday: Double {
        min(Double(consumptionModel.dailyWater) / Double(consumptionModel.waterGoal), 1.0)
    }
    
    var waterProgressYesterday: Double {
        min(Double(consumptionModel.yesterdayWater) / Double(consumptionModel.waterGoal), 1.0)
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
                    .overlay(Text("\(consumptionModel.yesterdayCalories) kcal").font(.caption).foregroundColor(.white), alignment: .trailing)
                
                ProgressView(value: waterProgressYesterday, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .frame(height: 10)
                    .overlay(Text("\(consumptionModel.yesterdayWater) mL").font(.caption).foregroundColor(.white), alignment: .trailing)
            }
            
            // Water Comparison
            VStack(alignment: .leading) {
                Text("Today")
                    .font(.caption)
                
                ProgressView(value: calorieProgressToday, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .red))
                    .frame(height: 10)
                    .overlay(Text("\(consumptionModel.dailyCalories) kcal").font(.caption).foregroundColor(.white), alignment: .trailing)
                
                ProgressView(value: waterProgressToday, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .frame(height: 10)
                    .overlay(Text("\(consumptionModel.dailyWater) mL").font(.caption).foregroundColor(.white), alignment: .trailing)
            }
        }
        .padding()
    }
}
