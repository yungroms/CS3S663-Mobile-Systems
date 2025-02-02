//
//  WaterIntakeViewModel.swift
//  ConsumptionApp
//
//  Created by Morris-Stiff R O (FCES) on 02/02/2025.
//

import Foundation
import SwiftUI

class WaterIntakeViewModel: ObservableObject {
    @Published var waterConsumed: Double {
        didSet {
            saveWaterConsumed()
        }
    }
    
    init() {
        self.waterConsumed = UserDefaults.standard.double(forKey: "waterConsumed")
    }
    
    func addWater(_ amount: Double) {
        waterConsumed += amount
    }
    
    func resetWaterIntake() {
        waterConsumed = 0
    }
    
    private func saveWaterConsumed() {
        UserDefaults.standard.set(waterConsumed, forKey: "waterConsumed")
    }
}
