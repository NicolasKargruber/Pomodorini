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
        var endDate: Date?
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
    static var countingDown: PomodorinoTimerAttributes.ContentState {
        PomodorinoTimerAttributes.ContentState(endDate: Date.now.addingTimeInterval(25*60), formattedTime: "24:59", hexColor: Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)).toHex()!)
     }
    
    static var overtime: PomodorinoTimerAttributes.ContentState {
        PomodorinoTimerAttributes.ContentState(endDate: Date.now.addingTimeInterval(-10), formattedTime: "24:59", hexColor: Color(#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)).toHex()!)
     }
     
    static var ended: PomodorinoTimerAttributes.ContentState {
        PomodorinoTimerAttributes.ContentState(endDate: Date.now.addingTimeInterval(-20), formattedTime: "00:00", hexColor: Color(#colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)).toHex()!)
     }
}
