//
//  PomodorinoTimerLiveActivity.swift
//  PomodorinoTimer
//
//  Created by Nicolas Kargruber on 23.02.25.
//

import ActivityKit
import WidgetKit
import SwiftUI

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
            .activityBackgroundTint(Color.black)
            .activitySystemActionForegroundColor(Color.primary)

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

// Preview
#Preview("Notification", as: .content, using: PomodorinoTimerAttributes.preview) {
   PomodorinoTimerLiveActivity()
} contentStates: {
    PomodorinoTimerAttributes.ContentState.started
    PomodorinoTimerAttributes.ContentState.ended
}
