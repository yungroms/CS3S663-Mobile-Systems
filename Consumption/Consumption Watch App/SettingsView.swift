import SwiftUI
import WidgetKit

struct SettingsView: View {
    // Use UserDefaults with shared suite for widget compatibility
    @State private var calorieGoal: Int = UserDefaults(suiteName: "group.usw.rms.Consumption")?.integer(forKey: "calorieGoal") ?? 2000
    @State private var waterGoal: Int = UserDefaults(suiteName: "group.usw.rms.Consumption")?.integer(forKey: "waterGoal") ?? 2000
    
    var body: some View {
        VStack {
            Text("Set Daily Goals")
                .font(.headline)
                .padding(.top, 10)
            
            // Calorie Goal Section
            VStack {
                Stepper(value: $calorieGoal, in: 1500...4000, step: 100) {
                    Text("\(calorieGoal) kcal")
                        .font(.body) // Larger text for the value
                }
                .padding()
                
                Text("Calorie Goal")
                    .font(.subheadline)  // Smaller label text
                    .foregroundColor(.gray)  // To make the label less dominant
            }
            
            Divider()  // Separator between sections
            
            // Water Goal Section
            VStack {
                Stepper(value: $waterGoal, in: 1000...4000, step: 250) {
                    Text("\(waterGoal) mL")
                        .font(.body)  // Larger text for the value
                }
                //.padding()
                
                Text("Water Goal")
                    .font(.subheadline)  // Smaller label text
                    .foregroundColor(.gray)  // To make the label less dominant
            }
            
            // Save the values to the shared UserDefaults
            Button(action: {
                let sharedDefaults = UserDefaults(suiteName: "group.usw.rms.Consumption")
                sharedDefaults?.set(calorieGoal, forKey: "calorieGoal")
                sharedDefaults?.set(waterGoal, forKey: "waterGoal")
                sharedDefaults?.synchronize() // Ensure values are saved immediately
                print("Goals saved: Calorie Goal: \(calorieGoal), Water Goal: \(waterGoal)")
                
                WidgetCenter.shared.reloadAllTimelines()
            }) {
                Text("Save Goals")
                    .font(.body)
            }
            .buttonStyle(BorderedButtonStyle())
            .controlSize(.mini)
            //.padding(10)
        }
    }
}
