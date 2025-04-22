//
//  DashboardView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftUI
import SwiftData

struct DashboardView: View {

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
            Text("Consumption iOS")
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.top, 10)
            
            Spacer(minLength: 10) 

            ZStack {
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
                            gradient: Gradient(colors: [.green]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 16, lineCap: .round)
                    )
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))
                    .shadow(radius: 4)
                    .animation(.easeInOut, value: todayConsumptionData)
                
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
                            gradient: Gradient(colors: [.red]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 14, lineCap: .round)
                    )
                    .frame(width: 135, height: 135)
                    .rotationEffect(.degrees(-90))
                    .shadow(radius: 4)
                    .animation(.easeInOut, value: todayConsumptionData)

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
                            gradient: Gradient(colors: [.blue]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 13, lineCap: .round)
                    )
                    .frame(width: 110, height: 110)
                    .rotationEffect(.degrees(-90))
                    .shadow(radius: 4)
                    .animation(.easeInOut, value: todayConsumptionData)
            }
            .padding(.top, -10)
            .padding(.bottom, 24)
            .onAppear {
                isThisANewDay()
            }

            VStack(spacing: 4) {
                Text("Food: \(todayConsumptionData.first?.totalCalories ?? 0)/\(targetData.first?.calorieTarget ?? 2000) cals")
                    .font(.subheadline.bold())
                    .foregroundColor(.red)
                
                Text("Water: \(todayConsumptionData.first?.totalWater ?? 0)/\(targetData.first?.waterTarget ?? 2000) mL")
                    .font(.subheadline.bold())
                    .foregroundColor(.blue)
                
                Text("Steps: \(todayConsumptionData.first?.totalSteps ?? 0)/\(targetData.first?.stepTarget ?? 10000) steps")
                    .font(.subheadline.bold())
                    .foregroundColor(.green)
            }
            .padding(.top, 4)
            .padding(.bottom, 16)

            NavigationLink("Weekly Overview") {
                WeeklyCombinedChartView()
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.bottom, 4)
        }
    }

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
