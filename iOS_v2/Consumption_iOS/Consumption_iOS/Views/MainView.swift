//
//  MainView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 17/04/2025.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Dashboard content
                DashboardView()
                    .padding(.top, 16)

                Spacer(minLength: 24)

                HStack(spacing: 20) {
                    NavigationLink(destination: FoodEntryView()) {
                        MetricButton(label: "Food", systemImage: "fork.knife.circle.fill", color: .red)
                    }
                    NavigationLink(destination: WaterEntryView()) {
                        MetricButton(label: "Water", systemImage: "drop.circle.fill", color: .blue)
                    }
                }

                HStack(spacing: 20) {
                    NavigationLink(destination: StepEntryView()) {
                        MetricButton(label: "Steps", systemImage: "figure.walk.circle.fill", color: .green)
                    }
                    NavigationLink(destination: SettingsView()) {
                        MetricButton(label: "Settings", systemImage: "gearshape.circle.fill", color: .gray)
                    }
                }

                Spacer()
            }
            .padding()
        }
    }
}

struct MetricButton: View {
    let label: String
    let systemImage: String
    let color: Color

    var body: some View {
        VStack {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(color)

            Text(label)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}
