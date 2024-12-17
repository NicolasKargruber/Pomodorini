//
//  PomodorinoGrowth.swift
//  HyperfocusBreaker
//
//  Created by Nicolas Kargruber on 18.11.24.
//


import SwiftUI

struct PomodorinoGrowth {
    // TODO: Rename to "Pomdorino-ripeness-00"
    private static let growthStages: [(ripeness: Double, imageName: String)] = [
        (0.00, "Pomodorino-Unripest"),          // 0%
        (0.10, "Pomodorino-Unriper"),           // 10%
        //(0.20, "Pomodorino-Unripe"),            // 20%
        (0.30, "Pomodorino-Ripening"),          // 30%
        (0.60, "Pomodorino-Almost-Ripe"),       // 60%
        (0.96, "Pomodorino-Ripe"),              // 96%
        (1.20, "Pomodorino-Going-Bad"),         // 120%
        (1.50, "Pomodorino-Going-Badder"),      // 150%
        (2.00, "Pomodorino-Gone-Bad"),          // 200%
    ]
    
    // Function to get image for a given percentage position
    static func imageName(forRipeness ripeness: Double) throws -> String {
        if(ripeness >= 2.0) { return growthStages.last!.imageName }
        guard ripeness >= 0.0 && ripeness <= 2.0
        else {
            throw PomodorinoRipenessError.outOfRange(value: ripeness)
        }
        
        // Safely find the image
        if let stage = growthStages.last(where: { $0.ripeness <= ripeness }) {
            // TODO: Delete
            // print(image, position)
            
            return stage.imageName
        } else {
            throw PomodorinoRipenessError.noMatchingElement(value: ripeness)
        }
    }
}
