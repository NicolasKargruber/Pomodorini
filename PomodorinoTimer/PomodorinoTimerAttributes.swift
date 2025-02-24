//
//  PomodorinoTimerAttributes.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 23.02.25.
//


import ActivityKit
import SwiftUICore

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

// Preview
extension PomodorinoTimerAttributes {
    static var preview: PomodorinoTimerAttributes {
        PomodorinoTimerAttributes(taskLabel: "Lernen")
    }
}

// Preview
extension PomodorinoTimerAttributes.ContentState {
    static var started: PomodorinoTimerAttributes.ContentState {
        PomodorinoTimerAttributes.ContentState(formattedTime: "24:59", hexColor: Color.green.toHex()!)
     }
     
    static var ended: PomodorinoTimerAttributes.ContentState {
         PomodorinoTimerAttributes.ContentState(formattedTime: "00:00", hexColor: Color.red.toHex()!)
     }
}
