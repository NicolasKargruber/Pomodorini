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
                Text("PoModoRInI 🍅").font(.caption2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                HStack {
                    Text(context.attributes.taskLabel)
                    Spacer()
                    Text(timerInterval: context.state.timerInterval, countsDown: true)
                        .font(.title.bold()).multilineTextAlignment(.trailing)
                    
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                //.foregroundColor(.white)
                //.background(Color(hex:context.state.hexColor).colorMultiply(Color.white))
                //.activityBackgroundTint(Color.black)
                //.activitySystemActionForegroundColor(Color.primary)
            

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
                    Text("🍅")
                        .font(.title2).fontWeight(.black)
                        .padding(.horizontal, 8)
                    //.foregroundColor(Color(hex:context.state.hexColor))
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack {
                        Spacer()
                        Text(timerInterval: context.state.timerInterval, countsDown: true)
                            .font(.system(size: 48, weight: .black, design: .default))
                            .multilineTextAlignment(.center)
                            .cornerRadius(24)
                            //.foregroundColor(Color(hex:context.state.hexColor))
                        Spacer()
                    }
                }
            }
            // #2 COMPACT
            compactLeading: {
                Text(context.attributes.taskLabel).padding(4)
                    //.foregroundColor(Color(hex:context.state.hexColor))
            } compactTrailing: {
                Text(timerInterval: Date.now...Date.now.addingTimeInterval(10), countsDown: true)
                    .frame(width: 50).fontWeight(.heavy).multilineTextAlignment(.center)
                    //.foregroundColor(Color(hex:context.state.hexColor))
            }
            // #3 MINIMAL
            minimal: {
                Text("🍅")
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
}

#Preview("Expanded", as: .dynamicIsland(.expanded), using: PomodorinoTimerAttributes.preview) {
   PomodorinoTimerLiveActivity()
} contentStates: {
    PomodorinoTimerAttributes.ContentState.countingDown
    PomodorinoTimerAttributes.ContentState.overtime
}

#Preview("Compact", as: .dynamicIsland(.compact), using: PomodorinoTimerAttributes.preview) {
   PomodorinoTimerLiveActivity()
} contentStates: {
    PomodorinoTimerAttributes.ContentState.countingDown
    PomodorinoTimerAttributes.ContentState.overtime
}

#Preview("Minimal", as: .dynamicIsland(.minimal), using: PomodorinoTimerAttributes.preview) {
   PomodorinoTimerLiveActivity()
} contentStates: {
    PomodorinoTimerAttributes.ContentState.countingDown
    PomodorinoTimerAttributes.ContentState.overtime
}
