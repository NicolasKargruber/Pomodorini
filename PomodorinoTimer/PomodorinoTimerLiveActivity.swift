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
        // Dynamic (stateful) properties
        // <--
        var formattedTime: String
        var hexColor: String
        // -->
    }

    // Static (non-changing) properties
    // <--
    var taskLabel: String
    // -->
}

struct PomodorinoTimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PomodorinoTimerAttributes.self) { context in
            // Lock screen/banner UI
            HStack {
                Text(context.attributes.taskLabel)
                Spacer()
                Text(context.state.formattedTime).font(.title.bold())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color(hex:context.state.hexColor))
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
                    Text("Bottom \(context.state.formattedTime)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.formattedTime)")
            } minimal: {
                Text(context.state.formattedTime)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension PomodorinoTimerAttributes {
    fileprivate static var preview: PomodorinoTimerAttributes {
        PomodorinoTimerAttributes(taskLabel: "Lernen")
    }
}

extension PomodorinoTimerAttributes.ContentState {
    fileprivate static var started: PomodorinoTimerAttributes.ContentState {
        PomodorinoTimerAttributes.ContentState(formattedTime: "24:59", hexColor: Color.green.toHex()!)
     }
     
     fileprivate static var ended: PomodorinoTimerAttributes.ContentState {
         PomodorinoTimerAttributes.ContentState(formattedTime: "00:00", hexColor: Color.red.toHex()!)
     }
}

#Preview("Notification", as: .content, using: PomodorinoTimerAttributes.preview) {
   PomodorinoTimerLiveActivity()
} contentStates: {
    PomodorinoTimerAttributes.ContentState.started
    PomodorinoTimerAttributes.ContentState.ended
}
