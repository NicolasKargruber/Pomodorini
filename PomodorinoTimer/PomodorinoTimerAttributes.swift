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
        //var endDate: Date?
        //var hexColor: String
        var timerInterval: ClosedRange<Date>
    }

    // Static (non-changing) properties
    //var timerInterval: TimeInterval
    var taskLabel: String?
}

// Preview
extension PomodorinoTimerAttributes {
    static var preview: PomodorinoTimerAttributes {
        PomodorinoTimerAttributes(taskLabel: "Lernen 📚")
    }
}

// Preview
extension PomodorinoTimerAttributes.ContentState {
    static var countingDown: PomodorinoTimerAttributes.ContentState {
        PomodorinoTimerAttributes.ContentState(timerInterval: Date.now...Date.now.addingTimeInterval(10))
     }
    
    static var overtime: PomodorinoTimerAttributes.ContentState {
        PomodorinoTimerAttributes.ContentState(timerInterval: Date.now...Date.now)
     }
}
