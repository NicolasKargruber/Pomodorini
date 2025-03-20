//
//  AwarenessMessage.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 19.03.25.
//

struct AwarenessMessage {
    private static let messages = [
            "Still doing well? Getting Stuck?\nNeed a break?",
            "Scribble down your last thoughts before your break.",
            "Your Pomodorini History is waiting for you.",
            "Your Pomodorino's Goal is never your timer!",
            "Update the Goal's steps before starting your Pomodorino.",
            "Break your goal into chunks. Get as many done as possible.",
            "Use AI Tools to help break down your Goal.",
            "Awareness - remember you may stop the Timer any time.",
            "Breaks are your friend against Hyperfocus",
            "Long press the Pomodorini counter to reset it."
        ]
    
    static func random() -> String {
        messages.randomElement() ?? "Stay focused!"
    }
}
