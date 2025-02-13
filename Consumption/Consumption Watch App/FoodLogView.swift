//
//  FoodLogView.swift
//  Consumption
//
//  Created by Morris-Stiff R O (FCES) on 13/02/2025.
//

import SwiftUI

struct FoodLogView: View {
    @AppStorage("loggedFoods", store: UserDefaults(suiteName: "group.usw.rms.Consumption")) private var loggedFoodsData: Data?
    
    var loggedFoods: [FoodItem] {
        // Decode stored food items from UserDefaults if available
        guard let data = loggedFoodsData else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([FoodItem].self, from: data)) ?? []
    }

    var body: some View {
        VStack {
            Text("Meals Logged Today:")
                .font(.body)
                .padding()

            List {
                ForEach(loggedFoods, id: \.id) { food in
                    HStack {
                        Text(food.mealType)
                        Spacer()
                        Text("\(food.calories) kcal")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
        }
    }
}
