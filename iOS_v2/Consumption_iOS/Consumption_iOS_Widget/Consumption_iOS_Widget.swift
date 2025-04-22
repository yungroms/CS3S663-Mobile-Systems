//
//  Consumption_iOS_Widget.swift
//  Consumption_iOS_Widget
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import WidgetKit
import SwiftUI
import SwiftData

struct ConsumptionEntry: TimelineEntry {
    let date: Date
    let caloriesProgress: Double
    let waterProgress: Double
    let stepsProgress: Double
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ConsumptionEntry {
        .init(date: Date(), caloriesProgress: 0.5, waterProgress: 0.5, stepsProgress: 0.5)
    }

    func getSnapshot(in context: Context, completion: @escaping (ConsumptionEntry) -> Void) {
        completion(placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ConsumptionEntry>) -> Void) {
        // Shared model setup
        let schema = Schema([
            FoodEntry.self,
            WaterEntry.self,
            StepCountEntry.self,
            Target.self,
            DailyConsumption.self,
            NotificationSetting.self
        ])

        guard let sharedURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.usw.consumption") else {
            print("Failed to locate shared container URL")
            completion(Timeline(entries: [placeholder(in: context)], policy: .atEnd))
            return
        }

        let databaseURL = sharedURL.appendingPathComponent("consumption.db")

        let config = ModelConfiguration(schema: schema, url: databaseURL)
        let container: ModelContainer

        do {
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            print("Failed to load SwiftData container: \(error)")
            completion(Timeline(entries: [placeholder(in: context)], policy: .atEnd))
            return
        }

        let modelContext = ModelContext(container)

        let today = Calendar.current.startOfDay(for: Date())

        // Fetch today's consumption
        let consumption = (try? modelContext.fetch(
            FetchDescriptor<DailyConsumption>(
                predicate: #Predicate { $0.date == today }
            )
        ).first) ?? DailyConsumption()

        // Fetch targets
        let target = (try? modelContext.fetch(FetchDescriptor<Target>()).first) ?? Target()

        let entry = ConsumptionEntry(
            date: Date(),
            caloriesProgress: Double(consumption.totalCalories) / Double(target.calorieTarget),
            waterProgress: Double(consumption.totalWater) / Double(target.waterTarget),
            stepsProgress: Double(consumption.totalSteps) / Double(target.stepTarget)
        )

        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(15 * 60)))
        completion(timeline)
    }
}

struct ConsumptionWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today’s Progress")
                .font(.headline)

            ProgressView("Calories", value: min(entry.caloriesProgress, 1.0))
                .tint(.red)

            ProgressView("Water", value: min(entry.waterProgress, 1.0))
                .tint(.blue)

            ProgressView("Steps", value: min(entry.stepsProgress, 1.0))
                .tint(.green)
        }
        .padding()
    }
}

@main
struct Consumption_iOS_Widget: Widget {
    let kind: String = "Consumption_iOS_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ConsumptionWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Progress")
        .description("See your calorie, water, and step progress.")
        .supportedFamilies([.systemMedium])
    }
}
