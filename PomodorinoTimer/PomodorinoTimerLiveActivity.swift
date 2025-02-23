//
//  PomodorinoTimerLiveActivity.swift
//  PomodorinoTimer
//
//  Created by Nicolas Kargruber on 23.02.25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PomodorinoTimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct PomodorinoTimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PomodorinoTimerAttributes.self) { context in
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

extension PomodorinoTimerAttributes {
    fileprivate static var preview: PomodorinoTimerAttributes {
        PomodorinoTimerAttributes(name: "World")
    }
}

extension PomodorinoTimerAttributes.ContentState {
    fileprivate static var smiley: PomodorinoTimerAttributes.ContentState {
        PomodorinoTimerAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: PomodorinoTimerAttributes.ContentState {
         PomodorinoTimerAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: PomodorinoTimerAttributes.preview) {
   PomodorinoTimerLiveActivity()
} contentStates: {
    PomodorinoTimerAttributes.ContentState.smiley
    PomodorinoTimerAttributes.ContentState.starEyes
}
