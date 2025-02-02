//
//  AddMealView.swift
//  ConsumptionApp
//
//  Created by Morris-Stiff R O (FCES) on 02/02/2025.
//

import SwiftUI

struct AddMealView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var mealVM: MealViewModel

    @State private var category = ""
    @State private var calories = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Meal Details")) {
                    TextField("Category (e.g., Breakfast, Snack)", text: $category)
                    TextField("Calories", text: $calories)
                        .onChange(of: calories) {
                            // Allow only numbers
                            calories = calories.filter { "0123456789".contains($0) }
                        }
                }

                Button("Add Meal") {
                    if let cal = Int(calories), !category.isEmpty {
                        mealVM.addMeal(category: category, calories: cal)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .disabled(category.isEmpty || calories.isEmpty)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .navigationTitle("Add Meal")
        }
    }
}

#Preview {
    AddMealView(mealVM: MealViewModel())
}
