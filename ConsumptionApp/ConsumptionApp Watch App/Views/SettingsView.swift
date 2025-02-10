import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var preferencesVM: UserPreferencesViewModel
    @ObservedObject var waterVM: WaterIntakeViewModel

    @State private var newWaterTarget: Double = 2.0 // Default starting point

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Water Goal")) {
                    VStack {
                        Text("Target: \(newWaterTarget, specifier: "%.1f") L")
                            .font(.headline)
                            .padding(.bottom, 4)

                        Slider(value: $newWaterTarget, in: 0...5, step: 0.1)
                            .accentColor(.blue)

                        Button("Update Target") {
                            preferencesVM.updateWaterTarget(to: newWaterTarget)
                            waterVM.updateTarget(newWaterTarget)
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }

                Section(header: Text("Reminders")) {
                    Toggle("Enable Reminders", isOn: $preferencesVM.preferences.remindersEnabled)
                        .onChange(of: preferencesVM.preferences.remindersEnabled) { _, _ in
                            preferencesVM.toggleReminders()
                        }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                newWaterTarget = preferencesVM.preferences.waterTarget
            }
        }
    }
}

#Preview {
    SettingsView(preferencesVM: UserPreferencesViewModel(), waterVM: WaterIntakeViewModel())
}
