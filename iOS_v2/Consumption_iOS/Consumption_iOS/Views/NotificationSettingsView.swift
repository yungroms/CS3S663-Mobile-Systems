//
//  NotificationSettingsView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 14/04/2025.
//

import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    // Default times are set via a computed closure to generate Date objects from fixed hour/minute.
    @State private var breakfastTime: Date = {
        var comps = DateComponents()
        comps.hour = 8
        comps.minute = 0
        return Calendar.current.date(from: comps) ?? Date()
    }()
    
    @State private var lunchTime: Date = {
        var comps = DateComponents()
        comps.hour = 12
        comps.minute = 0
        return Calendar.current.date(from: comps) ?? Date()
    }()
    
    @State private var dinnerTime: Date = {
        var comps = DateComponents()
        comps.hour = 18
        comps.minute = 0
        return Calendar.current.date(from: comps) ?? Date()
    }()
    
    @State private var showConfirmation = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Meal Reminder Times")) {
                    DatePicker("Breakfast Time", selection: $breakfastTime, displayedComponents: .hourAndMinute)
                    DatePicker("Lunch Time", selection: $lunchTime, displayedComponents: .hourAndMinute)
                    DatePicker("Dinner Time", selection: $dinnerTime, displayedComponents: .hourAndMinute)
                }
                
                Section {
                    Button("Save Reminders") {
                        // Convert selected dates into DateComponents (only hour and minute)
                        let breakfastComponents = Calendar.current.dateComponents([.hour, .minute], from: breakfastTime)
                        let lunchComponents = Calendar.current.dateComponents([.hour, .minute], from: lunchTime)
                        let dinnerComponents = Calendar.current.dateComponents([.hour, .minute], from: dinnerTime)
                        
                        NotificationManager.shared.scheduleMealReminders(breakfastTime: breakfastComponents,
                                                                        lunchTime: lunchComponents,
                                                                        dinnerTime: dinnerComponents)
                        showConfirmation = true
                    }
                    .alert(isPresented: $showConfirmation) {
                        Alert(title: Text("Reminders Updated"),
                              message: Text("Your meal reminder times have been saved."),
                              dismissButton: .default(Text("OK")))
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
            }
            .navigationTitle("Notification Settings")
        }
    }
}
