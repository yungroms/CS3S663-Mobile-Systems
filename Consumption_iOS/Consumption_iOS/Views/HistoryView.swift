//
//  HistoryView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: TrackerViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Calorie History")) {
                    ForEach(viewModel.foodEntries, id: \.id) { entry in
                        VStack(alignment: .leading) {
                            Text(entry.category)
                                .font(.headline)
                            Text("\(entry.calories) kcal")
                                .font(.subheadline)
                            Text("\(entry.date, formatter: dateFormatter)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("History")
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()
