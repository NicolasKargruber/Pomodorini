//
//  PomodorinoGrowth.swift
//  HyperfocusBreaker
//
//  Created by Nicolas Kargruber on 18.11.24.
//


import SwiftUI

struct PomodorinoGrowth {
    // TODO: Rename to "Pomdorino-gradient-00"
    private static let images: [(position: Double, name: String)] = [
        (0.00, "Pomodorino-Unripest"),          // 0%
        (0.10, "Pomodorino-Unriper"),           // 10%
        (0.20, "Pomodorino-Unripe"),            // 20%
        (0.30, "Pomodorino-Ripening"),          // 30%
        (0.60, "Pomodorino-Almost-Ripe"),       // 60%
        (0.96, "Pomodorino-Ripe"),              // 96%
        (1.20, "Pomodorino-Going-Bad"),         // 120%
        (1.50, "Pomodorino-Going-Badder"),      // 150%
        (2.00, "Pomodorino-Gone-Bad"),          // 200%
    ]
    
    // Function to get image for a given percentage position
    static func imageName(for position: Double) throws -> String {
        guard position >= 0.0 && position <= 2.0
        else {
            throw PomodorinoRipenessError.outOfRange(value: position)
        }
        
        // Safely find the image
        if let image = images.last(where: { $0.position <= position }) {
            // TODO: Delete
            // print(image, position)
            
            return image.name
        } else {
            throw PomodorinoRipenessError.noMatchingElement(value: position)
        }
    }
}
