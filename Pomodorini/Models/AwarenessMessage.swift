//
//  AwarenessMessage.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 19.03.25.
//

struct AwarenessMessage {
    private static let messages = [
            "Still doing well? Getting Stuck?\nNeed a break?",
            "Scribble down your last thoughts to take of right where you left of.",
            "Break your goal into chunks. Get as many done as possible.",
            "You may use an AI Tools to help you break down your Goal.",
            "Awareness - remember you may stop the Timer any time.",
            "Breaks are essential and your friend against Hyperfocus",
            "Reset the Pomodorini Counter by long pressing it"
        ]
    
    static func random() -> String {
        messages.randomElement() ?? "Stay focused!"
    }
}
