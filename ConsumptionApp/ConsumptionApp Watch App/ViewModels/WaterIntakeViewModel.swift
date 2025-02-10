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
    
    @Published var targetLitres: Double {
        didSet {
            saveTargetLitres()
        }
    }
    
    init() {
        self.waterConsumed = UserDefaults.standard.double(forKey: "waterConsumed")
        self.targetLitres = UserDefaults.standard.double(forKey: "targetLitres")
        
        // Default target if none saved
        if self.targetLitres == 0 {
            self.targetLitres = 2.0
        }
    }
    
    func addWater(_ amount: Double) {
        waterConsumed += amount
    }
    
    func resetWaterIntake() {
        waterConsumed = 0
    }
    
    func updateTarget(_ newTarget: Double) {
        targetLitres = newTarget
    }
    
    private func saveWaterConsumed() {
        UserDefaults.standard.set(waterConsumed, forKey: "waterConsumed")
    }
    
    private func saveTargetLitres() {
        UserDefaults.standard.set(targetLitres, forKey: "targetLitres")
    }
}
