//
//  HistoryView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: TrackerViewModel
    
    // Sorted days for which there are entries – newest first.
    private var sortedDays: [Date] {
        viewModel.foodEntriesByDay.keys.sorted(by: >)
    }
    
    var body: some View {
        NavigationView {
            List {
                // Loop through each day (grouped by start of day).
                ForEach(sortedDays, id: \.self) { day in
                    Section(header: Text(day, formatter: dateFormatter)) {
                        // For each food entry on this day.
                        ForEach(viewModel.foodEntriesByDay[day] ?? [], id: \.id) { entry in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry.mealName)
                                    .font(.headline)
                                Text(entry.category)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("\(entry.calories) kcal")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("\(entry.date, formatter: timeFormatter)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
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

// Date formatter for the section header (day)
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

// Time formatter to display the time for each entry.
private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()
