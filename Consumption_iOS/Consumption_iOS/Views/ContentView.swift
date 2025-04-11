//
//  ContentView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // Retrieve the TrackerViewModel that was injected by our wrapper.
    @EnvironmentObject var viewModel: TrackerViewModel

    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house")
                }
            EntryView()
                .tabItem {
                    Label("Log Entry", systemImage: "plus.circle")
                }
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
            TargetSettingView()
                .tabItem {
                    Label("Targets", systemImage: "flag")
                }
        }
    }
}
