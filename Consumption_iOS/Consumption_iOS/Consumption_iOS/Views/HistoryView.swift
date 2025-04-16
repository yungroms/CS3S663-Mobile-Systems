//
//  HistoryView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    // No more @EnvironmentObject var viewModel
    // Instead, we query all FoodEntry objects from SwiftData.
    @Query(sort: \FoodEntry.date, order: .reverse) private var allFoodEntries: [FoodEntry]

    // Group and sort them by day
    private var entriesByDay: [Date: [FoodEntry]] {
        Dictionary(grouping: allFoodEntries) { entry in
            Calendar.current.startOfDay(for: entry.date)
        }
    }

    // Sorted list of days (newest first)
    private var sortedDays: [Date] {
        entriesByDay.keys.sorted(by: >)
    }

    var body: some View {
        NavigationView {
            List {
                // For each day (grouped by startOfDay).
                ForEach(sortedDays, id: \.self) { day in
                    Section(header: Text(day, formatter: dateFormatter)) {
                        // For each food entry on this day
                        ForEach(entriesByDay[day] ?? [], id: \.id) { entry in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry.mealName)
                                    .font(.headline)
                                Text(entry.category)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("\(entry.calories) kcal")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Meal History")
        }
    }
}

// MARK: - Date Formatters
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

