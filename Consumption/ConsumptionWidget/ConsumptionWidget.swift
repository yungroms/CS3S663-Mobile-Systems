//
//  ConsumptionWidget.swift
//  ConsumptionWidget
//
//  Created by Morris-Stiff R O (FCES) on 10/02/2025.
//

import WidgetKit
import SwiftUI
import CoreData

// MARK: - Timeline Entry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let dailyCalories: Int
    let dailyWater: Int
    let calorieGoal: Int
    let waterGoal: Int
}

// MARK: - Timeline Provider
struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), dailyCalories: 0, dailyWater: 0, calorieGoal: 2000, waterGoal: 2000)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = fetchDataForWidget() ?? SimpleEntry(date: Date(), dailyCalories: 0, dailyWater: 0, calorieGoal: 2000, waterGoal: 2000)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        guard let currentEntry = fetchDataForWidget() else {
            let fallback = SimpleEntry(date: Date(), dailyCalories: 0, dailyWater: 0, calorieGoal: 2000, waterGoal: 2000)
            let timeline = Timeline(entries: [fallback], policy: .atEnd)
            completion(timeline)
            return
        }
        
        // Create timeline entries for the next 5 hours using the same fetched totals.
        let currentDate = Date()
        var entries: [SimpleEntry] = []
        for hourOffset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let timelineEntry = SimpleEntry(date: entryDate,
                                            dailyCalories: currentEntry.dailyCalories,
                                            dailyWater: currentEntry.dailyWater,
                                            calorieGoal: currentEntry.calorieGoal,
                                            waterGoal: currentEntry.waterGoal)
            entries.append(timelineEntry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func fetchDataForWidget() -> SimpleEntry? {
        let context = PersistenceController.shared.container.viewContext
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // Fetch today's FoodEntry objects.
        let foodRequest: NSFetchRequest<FoodEntry> = FoodEntry.fetchRequest()
        foodRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        
        // Fetch today's WaterEntry objects.
        let waterRequest: NSFetchRequest<WaterEntry> = WaterEntry.fetchRequest()
        waterRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        
        // Fetch AppSettings for goal values.
        let settingsRequest: NSFetchRequest<ConsumptionSettings> = ConsumptionSettings.fetchRequest()
        
        do {
            let foodEntries = try context.fetch(foodRequest)
            let totalCalories = foodEntries.reduce(0) { $0 + Int($1.calories) }
            
            let waterEntries = try context.fetch(waterRequest)
            let totalWater = waterEntries.reduce(0) { $0 + Int($1.amount) }
            
            let settingsResults = try context.fetch(settingsRequest)
            let settings: ConsumptionSettings
            if let existing = settingsResults.first {
                settings = existing
            } else {
                // Use defaults if no settings are found.
                settings = ConsumptionSettings(context: context)
                settings.calorieGoal = 2000
                settings.waterGoal = 2000
            }
            
            return SimpleEntry(date: Date(),
                               dailyCalories: totalCalories,
                               dailyWater: totalWater,
                               calorieGoal: Int(settings.calorieGoal),
                               waterGoal: Int(settings.waterGoal))
        } catch {
            print("Error fetching widget data: \(error.localizedDescription)")
            return nil
        }
    }

}

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
            // Left: Progress Bars
            VStack(spacing: 12) {
                VStack {
                    Text("Calories")
                        .font(.caption)
                        .foregroundColor(.red)
                    
                    ProgressView(value: calorieProgress, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: .red))
                        .frame(height: 10)
                }
                VStack {
                    Text("Water")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    ProgressView(value: waterProgress, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 10)
                }
            }
            .padding(.leading)
            
            // Right: Text Values
            VStack(spacing: 2) {
                Text("\(entry.dailyCalories)/\(entry.calorieGoal) kcal")
                    .font(.caption)
                    .foregroundColor(.red)
                Text("\(entry.dailyWater)/\(entry.waterGoal) mL")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            .padding(.leading, 10)
        }
    }
}

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
