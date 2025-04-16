//
//  DashboardView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    // We remove the environment object for TrackerViewModel entirely.
    // If we do not need insertion logic or getLast7DaysConsumption, we can remove it.

    @Environment(\.modelContext) private var modelContext
    
    @Query(
        filter: DailyConsumption.todayPredicate(),
        sort: \DailyConsumption.date,
        order: .reverse
    ) private var todayConsumptionData: [DailyConsumption]

    @Query(
        filter: Target.todayPredicate(),
        sort: \Target.date,
        order: .reverse
    ) private var targetData: [Target]

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                // Outer Ring: Steps (Green)
                Circle()
                    .trim(
                        from: 0,
                        to: progress(
                            steps: todayConsumptionData.first?.totalSteps ?? 0,
                            target: targetData.first?.stepTarget ?? 10000
                        )
                    )
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.green, .green.opacity(0.6)]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                    .shadow(radius: 4)
                    // Animate changes if aggregator updates
                    .animation(.easeInOut, value: todayConsumptionData)

                // Middle Ring: Food (Red)
                Circle()
                    .trim(
                        from: 0,
                        to: progress(
                            calories: todayConsumptionData.first?.totalCalories ?? 0,
                            target: targetData.first?.calorieTarget ?? 2000
                        )
                    )
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.red, .red.opacity(0.6)]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .shadow(radius: 4)
                    .animation(.easeInOut, value: todayConsumptionData)

                // Inner Ring: Water (Blue)
                Circle()
                    .trim(
                        from: 0,
                        to: progress(
                            water: todayConsumptionData.first?.totalWater ?? 0,
                            target: targetData.first?.waterTarget ?? 2000
                        )
                    )
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .blue.opacity(0.6)]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                    .shadow(radius: 4)
                    .animation(.easeInOut, value: todayConsumptionData)
            }
            .padding(.horizontal)
            .onAppear {
                isThisANewDay()
            }

            // Daily summary text
            VStack(spacing: 4) {
                Text("Food: \(todayConsumptionData.first?.totalCalories ?? 0)/\(targetData.first?.calorieTarget ?? 2000)")
                    .font(.subheadline.bold())
                    .foregroundColor(.red)
                
                Text("Water: \(todayConsumptionData.first?.totalWater ?? 0)/\(targetData.first?.waterTarget ?? 2000)")
                    .font(.subheadline.bold())
                    .foregroundColor(.blue)
                
                Text("Steps: \(todayConsumptionData.first?.totalSteps ?? 0)/\(targetData.first?.stepTarget ?? 10000)")
                    .font(.subheadline.bold())
                    .foregroundColor(.green)
            }
            .padding(.top, 4)
            
            // Optionally remove or replace the old "Weekly Trends" link
            // if you want to do a SwiftData-based approach for multiple days.
            // Example placeholder link:
            NavigationLink("Weekly Trends") {
                Text("Implement your SwiftData-based multi-day chart here.")
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .padding(.horizontal)
        }
    }

    // MARK: - "New Day" Aggregator
    func isThisANewDay() {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!

        let todayConsumptionRecord = todayConsumptionData.first {
            $0.date >= startOfToday && $0.date < startOfTomorrow
        }

        if todayConsumptionRecord == nil {
            print("It's a new day; inserting aggregator record.")
            let newRecord = DailyConsumption()
            modelContext.insert(newRecord)
            try? modelContext.save()
        } else {
            print("Today's record already exists.")
        }
    }
    
    // MARK: - Progress Helpers
    private func progress(calories: Int, target: Int) -> Double {
        guard target > 0 else { return 0.0 }
        return min(Double(calories) / Double(target), 1.0)
    }
    private func progress(water: Int, target: Int) -> Double {
        guard target > 0 else { return 0.0 }
        return min(Double(water) / Double(target), 1.0)
    }
    private func progress(steps: Int, target: Int) -> Double {
        guard target > 0 else { return 0.0 }
        return min(Double(steps) / Double(target), 1.0)
    }
}
