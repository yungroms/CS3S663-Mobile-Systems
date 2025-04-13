//
//  ContentView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var viewModel: TrackerViewModel  // Injected from the wrapper
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house")
                }
            
            FoodEntryView()
                .tabItem {
                    Label("Food", systemImage: "fork.knife")
                }
            
            WaterEntryView()
                .tabItem {
                    Label("Water", systemImage: "drop.fill")
                }
            
            StepEntryView()
                .tabItem {
                    Label("Steps", systemImage: "figure.walk")
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
