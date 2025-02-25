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
            VStack {
                Text("POMODORINI").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading).font(.caption2)
                HStack {
                    Text(context.attributes.taskLabel)
                    Spacer()
                    Text(context.state.endDate ?? Date.now, style: .timer)
                        .font(.title.bold()).multilineTextAlignment(.trailing)
                    
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color(hex:context.state.hexColor).colorMultiply(Color.white))
                .activityBackgroundTint(Color.black)
                .activitySystemActionForegroundColor(Color.primary)
            

        } dynamicIsland: { context in
            DynamicIsland {
                // #1 EXPANDED
                DynamicIslandExpandedRegion(.center) {
                    Text(context.attributes.taskLabel).font(.title)
                }
                DynamicIslandExpandedRegion(.leading) {
                    //Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Image(systemName: "apple.meditate")
                        .fontWeight(.black).foregroundColor(Color(hex:context.state.hexColor)).padding(.horizontal, 8)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack {
                        Spacer()
                        Text(context.state.endDate ?? Date.now, style: .timer)
                            .font(.system(size: 48, weight: .black, design: .default))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(hex:context.state.hexColor)).cornerRadius(24)
                        Spacer()
                    }
                }
            }
            // #2 COMPACT
            compactLeading: {
                Text(context.attributes.taskLabel).padding(4)
                    .foregroundColor(Color(hex:context.state.hexColor))
            } compactTrailing: {
                Text(context.state.endDate ?? Date.now, style: .timer).frame(width: 50)
                    .fontWeight(.heavy).multilineTextAlignment(.center)
                    .foregroundColor(Color(hex:context.state.hexColor))
            }
            // #3 MINIMAL
            minimal: {
                Image(systemName: "apple.meditate")
                    .fontWeight(.black).foregroundColor(Color(hex:context.state.hexColor))
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

// Preview
#Preview("Banner", as: .content, using: PomodorinoTimerAttributes.preview) {
   PomodorinoTimerLiveActivity()
} contentStates: {
    PomodorinoTimerAttributes.ContentState.countingDown
    PomodorinoTimerAttributes.ContentState.overtime
    PomodorinoTimerAttributes.ContentState.ended
}

#Preview("Expanded", as: .dynamicIsland(.expanded), using: PomodorinoTimerAttributes.preview) {
   PomodorinoTimerLiveActivity()
} contentStates: {
    PomodorinoTimerAttributes.ContentState.countingDown
    PomodorinoTimerAttributes.ContentState.overtime
    PomodorinoTimerAttributes.ContentState.ended
}

#Preview("Compact", as: .dynamicIsland(.compact), using: PomodorinoTimerAttributes.preview) {
   PomodorinoTimerLiveActivity()
} contentStates: {
    PomodorinoTimerAttributes.ContentState.countingDown
    PomodorinoTimerAttributes.ContentState.overtime
    PomodorinoTimerAttributes.ContentState.ended
}

#Preview("Minimal", as: .dynamicIsland(.minimal), using: PomodorinoTimerAttributes.preview) {
   PomodorinoTimerLiveActivity()
} contentStates: {
    PomodorinoTimerAttributes.ContentState.countingDown
    PomodorinoTimerAttributes.ContentState.overtime
    PomodorinoTimerAttributes.ContentState.ended
}
