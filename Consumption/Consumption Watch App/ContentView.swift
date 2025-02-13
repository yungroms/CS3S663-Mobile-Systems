import SwiftUI
import UserNotifications
import WidgetKit

struct ContentView: View {
    @AppStorage("dailyCalories", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var dailyCalories: Int = 0
    @AppStorage("dailyWater", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var dailyWater: Int = 0
    @AppStorage("calorieGoal", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var calorieGoal: Int = 2000
    @AppStorage("waterGoal", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var waterGoal: Int = 2000
    @AppStorage("lastResetDate", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var lastResetDate: Date = Date()

    @State private var showFoodLogView = false // Track if Food Log View is visible
    @State private var showComparisonView = false // Track if Comparison View is visible
    @State private var calorieProgress: Double = 0.0
    @State private var waterProgress: Double = 0.0
    @State private var timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    @State private var dragOffset = CGSize.zero // Track the drag gesture offset

    var body: some View {
            NavigationView {
                ZStack {
                    if showComparisonView {
                        ComparisonView()
                            .transition(.move(edge: .bottom))
                    } else if showFoodLogView {
                        FoodLogView()
                            .transition(.move(edge: .trailing)) // Appears from the left when swiping right
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
                                    if value.translation.height > 50 { // Swipe down to go back to ContentView
                                        showComparisonView = false
                                    }
                                } else if showFoodLogView {
                                    if value.translation.width < -50 { // Swipe left to go back to ContentView
                                        showFoodLogView = false
                                    }
                                } else { // ContentView swipes
                                    if value.translation.height < -50 { // Swipe up to ComparisonView
                                        showComparisonView = true
                                    } else if value.translation.width > 50 { // Swipe right to FoodLogView
                                        showFoodLogView = true
                                    }
                                }
                            }
                            dragOffset = .zero // Reset offset after swipe
                        }
                )
            }
        }

    private func mainControlView() -> some View {
        VStack {
            ZStack {
                Circle()
                    .trim(from: 0.0, to: CGFloat(calorieProgress))
                    .stroke(Color.red, style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))

                Circle()
                    .trim(from: 0.0, to: CGFloat(waterProgress))
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))

                VStack {
                    Text("\(dailyCalories)/\(calorieGoal) kcal")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .minimumScaleFactor(0.8)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)

                    Text("\(dailyWater)/\(waterGoal) mL")
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
        .onAppear {
            resetIfNeeded()
            checkForMidnightReset()
            updateProgress()
            scheduleDailyReminders()
        }
        .onChange(of: dailyCalories) { _, _ in updateProgress() }
        .onChange(of: dailyWater) { _, _ in updateProgress() }
        .onChange(of: calorieGoal) { _, _ in updateProgress() }
        .onReceive(timer) { _ in checkForMidnightReset()
        }
    }

    private func updateProgress() {
        calorieProgress = min(Double(dailyCalories) / Double(calorieGoal), 1.0)
        waterProgress = min(Double(dailyWater) / Double(waterGoal), 1.0)
    }

    // Function to schedule reminders for meals
    func scheduleReminder(for meal: String, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Time to Log \(meal)"
        content.body = "Remember to log your \(meal) calories and water intake."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "\(meal)Reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling reminder for \(meal): \(error.localizedDescription)")
            } else {
                print("\(meal) reminder scheduled successfully.")
            }
        }
    }

    // Function to schedule daily reminders for food and water logging
    func scheduleDailyReminders() {
        // Schedule reminders for breakfast, lunch, and dinner
        scheduleReminder(for: "Breakfast", hour: 8, minute: 0)  // 8:00 AM
        scheduleReminder(for: "Lunch", hour: 12, minute: 0)     // 12:00 PM
        scheduleReminder(for: "Dinner", hour: 18, minute: 0)    // 6:00 PM
    }
    
    private func checkForMidnightReset() {
        let calendar = Calendar.current
        let currentDate = Date()
        let lastResetDay = calendar.startOfDay(for: lastResetDate)
        let today = calendar.startOfDay(for: currentDate)

        if today != lastResetDay {
            dailyCalories = 0
            dailyWater = 0
            lastResetDate = currentDate

            let sharedDefaults = UserDefaults(suiteName: "group.usw.rms.Consumption")
            sharedDefaults?.set(dailyCalories, forKey: "dailyCalories")
            sharedDefaults?.set(dailyWater, forKey: "dailyWater")
            sharedDefaults?.set(lastResetDate, forKey: "lastResetDate")
            sharedDefaults?.synchronize()

            print("Daily values reset at midnight")
        }
    }

    func resetIfNeeded() {
        let sharedDefaults = UserDefaults(suiteName: "group.usw.rms.Consumption")
        let calendar = Calendar.current
        let lastResetDate = sharedDefaults?.object(forKey: "lastResetDate") as? Date ?? Date.distantPast
        let today = Date()

        if !calendar.isDate(lastResetDate, inSameDayAs: today) {
            print("Midnight Reset: Saving yesterday's data and resetting daily values")

            // Save yesterday's values
            let yesterdayCalories = sharedDefaults?.integer(forKey: "dailyCalories") ?? 0
            let yesterdayWater = sharedDefaults?.integer(forKey: "dailyWater") ?? 0
            sharedDefaults?.set(yesterdayCalories, forKey: "yesterdayCalories")
            sharedDefaults?.set(yesterdayWater, forKey: "yesterdayWater")

            // Reset today's values
            sharedDefaults?.set(0, forKey: "dailyCalories")
            sharedDefaults?.set(0, forKey: "dailyWater")
            sharedDefaults?.set(today, forKey: "lastResetDate")
            sharedDefaults?.synchronize()

            // Refresh the widget
            WidgetCenter.shared.reloadAllTimelines()
        } else {
            print("No reset needed: Already updated today.")
        }
    }
}
