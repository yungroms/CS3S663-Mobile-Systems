//
//  Consumption_iOS_WidgetLiveActivity.swift
//  Consumption_iOS_Widget
//
//  Created by Morris-Stiff R O (FCES) on 11/04/2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Consumption_iOS_WidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct Consumption_iOS_WidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Consumption_iOS_WidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension Consumption_iOS_WidgetAttributes {
    fileprivate static var preview: Consumption_iOS_WidgetAttributes {
        Consumption_iOS_WidgetAttributes(name: "World")
    }
}

extension Consumption_iOS_WidgetAttributes.ContentState {
    fileprivate static var smiley: Consumption_iOS_WidgetAttributes.ContentState {
        Consumption_iOS_WidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: Consumption_iOS_WidgetAttributes.ContentState {
         Consumption_iOS_WidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: Consumption_iOS_WidgetAttributes.preview) {
   Consumption_iOS_WidgetLiveActivity()
} contentStates: {
    Consumption_iOS_WidgetAttributes.ContentState.smiley
    Consumption_iOS_WidgetAttributes.ContentState.starEyes
}
