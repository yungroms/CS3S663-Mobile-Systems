//
//  SettingsView.swift
//  ConsumptionApp
//
//  Created by Morris-Stiff R O (FCES) on 02/02/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var preferencesVM: UserPreferencesViewModel
    @ObservedObject var waterVM: WaterIntakeViewModel

    @State private var newWaterTarget: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Water Goal")) {
                    TextField("Water Target (L)", text: $newWaterTarget)
                        .onChange(of: newWaterTarget) {
                            let filtered = newWaterTarget.filter { "0123456789.".contains($0) }
                            let decimalCount = filtered.filter { $0 == "." }.count
                            if decimalCount <= 1 {
                                newWaterTarget = filtered
                            } else {
                                newWaterTarget = String(filtered.dropLast())
                            }
                        }

                    Button("Update Target") {
                        if let target = Double(newWaterTarget) {
                            preferencesVM.updateWaterTarget(to: target)
                            waterVM.updateTarget(target)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(newWaterTarget.isEmpty)
                }

                Section(header: Text("Reminders")) {
                    Toggle("Enable Reminders", isOn: $preferencesVM.preferences.remindersEnabled)
                        .onChange(of: preferencesVM.preferences.remindersEnabled) {
                            preferencesVM.toggleReminders()
                        }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView(preferencesVM: UserPreferencesViewModel(), waterVM: WaterIntakeViewModel())
}
