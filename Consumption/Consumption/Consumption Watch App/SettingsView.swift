import SwiftUI
import WidgetKit

struct SettingsView: View {
    @EnvironmentObject var consumptionModel: ConsumptionModel

    var body: some View {
        VStack {
            Text("Set Daily Goals")
                .font(.headline)
            
            // Calorie Goal Section
            VStack {
                Stepper(value: $consumptionModel.calorieGoal, in: 1500...4000, step: 100) {
                    Text("\(consumptionModel.calorieGoal) kcal")
                        .font(.body)
                }
                .padding()
                
                Text("Calorie Goal")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Divider()
            
            // Water Goal Section
            VStack {
                Stepper(value: $consumptionModel.waterGoal, in: 1000...4000, step: 250) {
                    Text("\(consumptionModel.waterGoal) mL")
                        .font(.body)
                }
                
                Text("Water Goal")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // Save Button
            Button(action: {
                print("Goals saved: Calorie Goal: \(consumptionModel.calorieGoal), Water Goal: \(consumptionModel.waterGoal)")
                WidgetCenter.shared.reloadAllTimelines()
            }) {
                Text("Save Goals")
                    .font(.body)
            }
            .buttonStyle(BorderedButtonStyle())
            .controlSize(.mini)
        }
    }
}
