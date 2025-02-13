//
//  ConsumptionWidget.swift
//  ConsumptionWidget
//
//  Created by Morris-Stiff R O (FCES) on 10/02/2025.
//

import WidgetKit
import SwiftUI

func resetIfNeeded() {
    let sharedDefaults = UserDefaults(suiteName: "group.usw.rms.Consumption")
    let calendar = Calendar.current
    let lastResetDate = sharedDefaults?.object(forKey: "lastResetDate") as? Date ?? Date.distantPast
    let today = Date()

    if !calendar.isDate(lastResetDate, inSameDayAs: today) {
        print("Midnight Reset: Saving yesterday's data and resetting daily values")

        // Save yesterday's values
        let yesterdayCalories = sharedDefaults?.integer(forKey: "dailyCalories") ?? 0
        let yesterdayWater = sharedDefaults?.integer(forKey: "dailyWater") ?? 0
        sharedDefaults?.set(yesterdayCalories, forKey: "yesterdayCalories")
        sharedDefaults?.set(yesterdayWater, forKey: "yesterdayWater")

        // Reset today's values
        sharedDefaults?.set(0, forKey: "dailyCalories")
        sharedDefaults?.set(0, forKey: "dailyWater")
        sharedDefaults?.set(today, forKey: "lastResetDate")
        sharedDefaults?.synchronize()

        // Refresh the widget
        WidgetCenter.shared.reloadAllTimelines()
    } else {
        print("No reset needed: Already updated today.")
    }
}

// Provider struct: This defines how the widget gets its data and updates.
struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry

    // Placeholder is used to show a preview of the widget in Widget Gallery
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), dailyCalories: 0, dailyWater: 0, calorieGoal: 2000, waterGoal: 2000)
    }

    // Snapshot generates a specific instance of widget for preview
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        resetIfNeeded()
        
        // Retrieve real data or placeholder data for preview purposes
        let sharedDefaults = UserDefaults(suiteName: "group.usw.rms.Consumption")
        let dailyCalories = sharedDefaults?.integer(forKey: "dailyCalories") ?? 0
        let dailyWater = sharedDefaults?.integer(forKey: "dailyWater") ?? 0
        let calorieGoal = sharedDefaults?.integer(forKey: "calorieGoal") ?? 2000
        let waterGoal = sharedDefaults?.integer(forKey: "waterGoal") ?? 2000

        let entry = SimpleEntry(date: Date(), dailyCalories: dailyCalories, dailyWater: dailyWater, calorieGoal: calorieGoal, waterGoal: waterGoal)
        completion(entry)
    }

    // Timeline generates a series of data entries, updating at regular intervals.
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        resetIfNeeded()
        
        let sharedDefaults = UserDefaults(suiteName: "group.usw.rms.Consumption")
        let dailyCalories = sharedDefaults?.integer(forKey: "dailyCalories") ?? 0
        let dailyWater = sharedDefaults?.integer(forKey: "dailyWater") ?? 0
        let calorieGoal = sharedDefaults?.integer(forKey: "calorieGoal") ?? 2000
        let waterGoal = sharedDefaults?.integer(forKey: "waterGoal") ?? 2000

        print("Widget Fetching Calories: \(dailyCalories)/\(calorieGoal), Water: \(dailyWater)/\(waterGoal)")

        let currentDate = Date()
        var entries: [SimpleEntry] = []

        for hourOffset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, dailyCalories: dailyCalories, dailyWater: dailyWater, calorieGoal: calorieGoal, waterGoal: waterGoal)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        [AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "Example Widget")]
    }
}

// SimpleEntry struct: This represents a piece of data that will be shown in the widget
struct SimpleEntry: TimelineEntry {
    let date: Date
    let dailyCalories: Int
    let dailyWater: Int
    let calorieGoal: Int
    let waterGoal: Int
}

// The widget view content that will display the progress of daily calories and water intake
struct ConsumptionWidgetEntryView: View {
    var entry: Provider.Entry
    
    var calorieProgress: Double {
        min(Double(entry.dailyCalories) / Double(entry.calorieGoal), 1.0)
    }
    
    var waterProgress: Double {
        min(Double(entry.dailyWater) / Double(entry.waterGoal), 1.0)
    }
    
    var body: some View {
        HStack {
            // Left: The Progress Bars (Calories & Water)
            VStack(spacing: 12) {
                // Progress Bar for Calories
                VStack {
                    Text("Calories")
                        .font(.caption)
                        .foregroundColor(.red)
                    
                    ProgressView(value: calorieProgress, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: .red))
                        .frame(height: 10) // Adjust the height for a slim bar
                }
                
                // Progress Bar for Water
                VStack {
                    Text("Water")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    ProgressView(value: waterProgress, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 10) // Adjust the height for a slim bar
                }
            }
            .padding(.leading)

            // Right: The Text (Calories & Water)
            VStack(spacing: 2) {
                Text("\(entry.dailyCalories)/\(entry.calorieGoal) kcal")
                    .font(.caption)
                    .foregroundColor(.red)

                Text("\(entry.dailyWater)/\(entry.waterGoal) mL")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            .padding(.leading, 10) // Add space between text and progress bars
        }
    }
    
    // The main widget configuration
    @main
    struct ConsumptionWidget: Widget {
        let kind: String = "ConsumptionWidget"
        
        var body: some WidgetConfiguration {
            StaticConfiguration(kind: kind, provider: Provider()) { entry in
                ConsumptionWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            }
            .configurationDisplayName("Consumption Widget")
            .description("Track your daily calorie and water intake.")
        }
    }
    
    #Preview(as: .accessoryRectangular) {
        ConsumptionWidget()
    } timeline: {
        SimpleEntry(date: .now, dailyCalories: 1000, dailyWater: 1500, calorieGoal: 2000, waterGoal: 2000)
    }
}
