//
//  ContentViewWrapper.swift
//  Consumption_iOS
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import SwiftUI
import SwiftData

struct ContentViewWrapper: View {
    @Environment(\.modelContext) var context
    
    var body: some View {
        ContentView()
            .environmentObject(TrackerViewModel(context: context))
    }
}
