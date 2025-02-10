import SwiftUI

struct ContentView: View {
    @StateObject private var mealVM = MealViewModel()
    @StateObject private var waterVM = WaterIntakeViewModel()
    @StateObject private var preferencesVM = UserPreferencesViewModel()

    @State private var showAddMeal = false
    @State private var showSettings = false
    @State private var crownValue: Double = 0.0  // Tracks Digital Crown rotation

    private func scheduleMidnightReset() {
        let now = Date()
        let calendar = Calendar.current
        let midnight = calendar.nextDate(after: now, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime)!
        let timeInterval = midnight.timeIntervalSince(now)
        
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            waterVM.resetWaterIntake()
            mealVM.resetMeals()
            scheduleMidnightReset() // Schedule the next reset
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Water Intake Progress
                VStack {
                    Text("Water Intake")
                        .font(.headline)
                    
                    ProgressView(
                        value: min(max(waterVM.waterConsumed, 0), waterVM.targetLitres),
                        total: waterVM.targetLitres
                    )
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .padding()


                    Text("\(waterVM.waterConsumed, specifier: "%.1f")L / \(waterVM.targetLitres, specifier: "%.1f")L")
                        .font(.caption)

                    // Digital Crown Input
                    Text("Adjust with Crown")
                        .font(.caption2)
                        .foregroundColor(.gray)

                    // Incremental Change with Crown
                    Slider(value: $crownValue, in: 0...5, step: 0.25)
                        .onChange(of: crownValue) {
                            waterVM.waterConsumed = crownValue
                        }
                        .padding()

                    // Quick Add Button
                    Button(action: { waterVM.addWater(0.25) }) {
                        Text("+250ml")
                            .padding(8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()

                Divider()

                // Meal List
                VStack {
                    Text("Meals & Snacks")
                        .font(.headline)

                    List {
                        ForEach(mealVM.meals) { meal in
                            VStack(alignment: .leading) {
                                Text(meal.category)
                                    .font(.headline)
                                Text("\(meal.calories) kcal")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .onDelete { indexSet in
                            mealVM.deleteMeal(at: indexSet)
                        }
                    }
                }

                Spacer()

                // Navigation Buttons
                HStack {
                    Button(action: { showAddMeal = true }) {
                        Label("Add Meal", systemImage: "plus")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: { showSettings = true }) {
                        Label("Settings", systemImage: "gear")
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .sheet(isPresented: $showAddMeal) {
                AddMealView(mealVM: mealVM)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(preferencesVM: preferencesVM, waterVM: waterVM)
            }
            .navigationTitle("Consumption Tracker")
            .onAppear {
                scheduleMidnightReset()
            }
        }
    }
}

#Preview {
    ContentView()
}
