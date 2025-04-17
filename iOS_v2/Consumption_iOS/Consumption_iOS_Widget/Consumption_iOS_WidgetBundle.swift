//
//  Consumption_iOS_WidgetBundle.swift
//  Consumption_iOS_Widget
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import WidgetKit
import SwiftUI

@main
struct Consumption_iOS_WidgetBundle: WidgetBundle {
    var body: some Widget {
        Consumption_iOS_Widget()
        Consumption_iOS_WidgetControl()
        Consumption_iOS_WidgetLiveActivity()
    }
}
