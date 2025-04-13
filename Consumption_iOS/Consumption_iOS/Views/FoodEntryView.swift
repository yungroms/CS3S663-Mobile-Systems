//
//  FoodEntryView.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 13/04/2025.
//

import SwiftUI

struct FoodEntryView: View {
    @EnvironmentObject var viewModel: TrackerViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var selectedMealType: String = "Breakfast"
    @State private var calorieInput: Int = 100

    let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Meal Type")) {
                    Picker("Meal Type", selection: $selectedMealType) {
                        ForEach(mealTypes, id: \.self) { meal in
                            Text(meal)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Calories (kcal)")) {
                    Stepper(value: $calorieInput, in: 50...2000, step: 50) {
                        Text("\(calorieInput) kcal")
                    }
                }
                
                Section {
                    Button(action: {
                        viewModel.addFoodEntry(category: selectedMealType, calories: calorieInput)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save Food Entry")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
            }
            .navigationTitle("Log Food")
        }
    }
}

//struct FoodEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodEntryView()
//            .environmentObject(TrackerViewModel(context: ModelContext.preview))
//    }
//}
