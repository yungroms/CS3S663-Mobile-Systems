import SwiftUI

struct AddMealView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var mealVM: MealViewModel

    @State private var selectedCategory = "Breakfast"
    @State private var calories: Double = 0

    let categories = ["Breakfast", "Lunch", "Dinner", "Snack"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Meal Details")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \ .self) { category in
                            Text(category)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())

                    Stepper(value: $calories, in: 0...2000, step: 50) {
                        Text("Calories: \(Int(calories)) kcal")
                    }
                    .focusable(true)
                    .digitalCrownRotation($calories, from: 0, through: 2000, by: 50)
                }

                Button("Add Meal") {
                    if calories > 0 {
                        mealVM.addMeal(category: selectedCategory, calories: Int(calories))
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .disabled(calories == 0)
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
