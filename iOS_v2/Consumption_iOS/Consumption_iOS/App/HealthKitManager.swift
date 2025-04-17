//
//  HealthKitManager.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 16/04/2025.
//

import HealthKit
import SwiftUI

class HealthKitManager {
    static let shared = HealthKitManager()
    
    let healthStore = HKHealthStore()

    // 1) Request authorization
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, nil)
            return
        }
        // We want stepCount read-access
        let stepType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let typesToRead: Set = [stepType]
        
        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            completion(success, error)
        }
    }

    // 2) Fetch the user’s steps for today
    func fetchTodaySteps(completion: @escaping (Double?, Error?) -> Void) {
        let stepType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let startOfDay = Calendar.current.startOfDay(for: Date())
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: Date(),
            options: .strictStartDate
        )
        
        // We want cumulative sum of steps for the day
        let query = HKStatisticsQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(nil, error)
                return
            }
            let steps = sum.doubleValue(for: HKUnit.count())
            completion(steps, nil)
        }
        healthStore.execute(query)
    }
}
