import SwiftUI
import CoreData

struct FoodLogView: View {
    
    @EnvironmentObject var consumptionModel: ConsumptionModel
    
    // Use @FetchRequest to retrieve FoodEntry objects from CoreData.
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FoodEntry.date, ascending: false)],
        predicate: {
             let calendar = Calendar.current
             let startOfDay = calendar.startOfDay(for: Date())
             let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
             return NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        }(),
        animation: .default
    )
    private var foodEntries: FetchedResults<FoodEntry>

    
    var body: some View {
        VStack {
            Text("Meals Logged Today:")
                .font(.body)
                .padding()
            
            List {
                // Use objectID as the identifier instead of self.
                ForEach(foodEntries, id: \.objectID) { entry in
                    HStack {
                        Text(entry.mealType ?? "Unknown")
                        Spacer()
                        Text("\(entry.calories) kcal")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
        }
    }
}
