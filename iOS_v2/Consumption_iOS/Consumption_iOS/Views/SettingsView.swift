//
//  SettingsView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftUI
import SwiftData
import WidgetKit
import UserNotifications

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var targetRecords: [Target]
    @Query private var notificationSettings: [NotificationSetting]

    @State private var calorieTarget: Int = 2000
    @State private var waterTarget: Int = 2000
    @State private var stepTarget: Int = 10000

    @State private var breakfastTime: Date = defaultTime(hour: 8)
    @State private var lunchTime: Date = defaultTime(hour: 12)
    @State private var dinnerTime: Date = defaultTime(hour: 18)

    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Target Settings")) {
                    Stepper("\(calorieTarget) kcal", value: $calorieTarget, in: 1000...5000, step: 100)
                    Stepper("\(waterTarget) mL", value: $waterTarget, in: 1000...4000, step: 250)
                    Stepper("\(stepTarget) steps", value: $stepTarget, in: 1000...30000, step: 500)
                }

                Section(header: Text("Notification Settings")) {
                    DatePicker("Breakfast", selection: $breakfastTime, displayedComponents: .hourAndMinute)
                    DatePicker("Lunch", selection: $lunchTime, displayedComponents: .hourAndMinute)
                    DatePicker("Dinner", selection: $dinnerTime, displayedComponents: .hourAndMinute)
                }

                Section {
                    Button("Save Settings") {
                        saveTargets()
                        saveNotifications()
                        alertMessage = "Your settings have been saved successfully."
                        showAlert = true
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Settings")
            .onAppear(perform: loadSettings)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Settings Saved"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func loadSettings() {
        if let target = targetRecords.first {
            calorieTarget = target.calorieTarget
            waterTarget = target.waterTarget
            stepTarget = target.stepTarget
        }

        if let notifications = notificationSettings.first {
            breakfastTime = notifications.breakfastTime
            lunchTime = notifications.lunchTime
            dinnerTime = notifications.dinnerTime
        }
    }

    private func saveTargets() {
        let target = targetRecords.first ?? Target()
        target.calorieTarget = calorieTarget
        target.waterTarget = waterTarget
        target.stepTarget = stepTarget

        target.date = Calendar.current.startOfDay(for: Date())

        if !targetRecords.contains(target) {
            modelContext.insert(target)
        }

        do {
            try modelContext.save()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("Save failed")
        }
    }

    private func saveNotifications() {
        let settings = notificationSettings.first ?? NotificationSetting()
        settings.breakfastTime = breakfastTime
        settings.lunchTime = lunchTime
        settings.dinnerTime = dinnerTime
        if !notificationSettings.contains(settings) {
            modelContext.insert(settings)
        }

        let breakfast = Calendar.current.dateComponents([.hour, .minute], from: breakfastTime)
        let lunch = Calendar.current.dateComponents([.hour, .minute], from: lunchTime)
        let dinner = Calendar.current.dateComponents([.hour, .minute], from: dinnerTime)

        NotificationManager.shared.scheduleMealReminders(
            breakfastTime: breakfast,
            lunchTime: lunch,
            dinnerTime: dinner
        )
    }

    private static func defaultTime(hour: Int) -> Date {
        var comps = DateComponents()
        comps.hour = hour
        comps.minute = 0
        return Calendar.current.date(from: comps) ?? Date()
    }
}
