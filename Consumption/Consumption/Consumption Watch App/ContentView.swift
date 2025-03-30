import SwiftUI
import UserNotifications
import WidgetKit

struct ContentView: View {
    // Inject the centralized model.
    @EnvironmentObject var consumptionModel: ConsumptionModel
    
    // Local state for view transitions.
    @State private var showFoodLogView = false
    @State private var showComparisonView = false
    @State private var dragOffset = CGSize.zero
    @State private var timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ZStack {
                if showComparisonView {
                    ComparisonView()
                        .transition(.move(edge: .bottom))
                } else if showFoodLogView {
                    FoodLogView()
                        .transition(.move(edge: .trailing))
                } else {
                    mainControlView()
                        .transition(.move(edge: .top))
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        withAnimation {
                            if showComparisonView {
                                if value.translation.height > 50 {
                                    showComparisonView = false
                                }
                            } else if showFoodLogView {
                                if value.translation.width < -50 {
                                    showFoodLogView = false
                                }
                            } else {
                                if value.translation.height < -50 {
                                    showComparisonView = true
                                } else if value.translation.width > 50 {
                                    showFoodLogView = true
                                }
                            }
                        }
                        dragOffset = .zero
                    }
            )
        }
        .onAppear {
            // Let the model handle resets and scheduling.
            consumptionModel.resetDailyIfNeeded()
            consumptionModel.scheduleDailyReminders()
            consumptionModel.recalculateDailyTotals()
        }
        .onReceive(timer) { _ in
            // You can perform periodic tasks here if needed.
        }
    }
    
    // Main control view with progress circles and navigation.
    private func mainControlView() -> some View {
        VStack {
            ZStack {
                // Progress for calories.
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(Double(consumptionModel.dailyCalories) / Double(consumptionModel.calorieGoal), 1.0)))
                    .stroke(Color.red, style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                
                // Progress for water.
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(Double(consumptionModel.dailyWater) / Double(consumptionModel.waterGoal), 1.0)))
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Text("\(consumptionModel.dailyCalories)/\(consumptionModel.calorieGoal) kcal")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .minimumScaleFactor(0.8)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    
                    Text("\(consumptionModel.dailyWater)/\(consumptionModel.waterGoal) mL")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .minimumScaleFactor(0.8)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            
            HStack {
                NavigationLink(destination: FoodLoggingView()) {
                    Text("Log Food")
                }
                .buttonStyle(BorderedButtonStyle())
                .controlSize(.mini)
                
                NavigationLink(destination: WaterLoggingView()) {
                    Text("Log Water")
                }
                .buttonStyle(BorderedButtonStyle())
                .controlSize(.mini)
            }
            
            NavigationLink(destination: SettingsView()) {
                Text("Settings")
            }
            .buttonStyle(BorderedButtonStyle())
            .controlSize(.mini)
        }
    }
}
