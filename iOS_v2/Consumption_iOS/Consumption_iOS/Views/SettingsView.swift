//
//  SettingsView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 17/04/2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section(header: Text("🎯 Target Settings")) {
                // Embed your existing TargetSettingView content here
                TargetSettingView()
            }

            Section(header: Text("🔔 Notification Settings")) {
                // Embed your existing NotificationSettingsView content here
                NotificationSettingsView()
            }
        }
        .navigationTitle("Settings")
    }
}
