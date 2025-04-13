//
//  StepEntryView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 13/04/2025.
//

import SwiftUI
import SwiftData  // Ensure SwiftData is imported

struct StepEntryView: View {
    @EnvironmentObject var viewModel: TrackerViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var stepInput: Int = 1000  // Default step count

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Steps Count")) {
                    Stepper(value: $stepInput, in: 0...20000, step: 500) {
                        Text("\(stepInput) steps")
                    }
                }
                
                Section {
                    Button(action: {
                        viewModel.addStepEntry(steps: stepInput)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save Step Entry")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
            }
            .navigationTitle("Log Steps")
        }
    }
}

struct StepEntryView_Previews: PreviewProvider {
    static var previews: some View {
        // Use try! to handle the throwing initializer in preview.
        let container = try! ModelContainer(for: FoodEntry.self, WaterEntry.self, StepCountEntry.self, Target.self)
        return StepEntryView()
            .environmentObject(TrackerViewModel(context: container.mainContext))
    }
}

