//
//  PomodorinoGrowth.swift
//  HyperfocusBreaker
//
//  Created by Nicolas Kargruber on 18.11.24.
//


import SwiftUI

struct PomodorinoGrowth {
    private static let growthStages: [(ripeness: Double, imageName: String, scale: CGFloat)] = [
        (0.00, "Pomodorino Unripe", 0.9),  // 0%
        (0.30, "Pomodorino Ripening", 1.1),  // 30%
        (0.60, "Pomodorino Ripening", 1.3),// 60%
        (0.96, "Pomodorino Ripe", 1.5),      // 96%
        (1.04, "Pomodorino Going Bad", 1.4), // 120%
        (1.20, "Pomodorino Going Badder", 1.4),// 120%
        (1.40, "Pomodorino Going Even Badder", 1.4),// 140%
        (1.60, "Pomodorino Squished", 1.4),// 160%
        (2.00, "Pomodorino Broke Open", 2.2),  // 200%
    ]
    
    // Function to get image and scale for a given ripeness
    static func imageInfo(forRipeness ripeness: Double) throws -> (imageName: String, scale: CGFloat) {
        if(ripeness >= 2.0) { return (growthStages.last!.imageName, growthStages.last!.scale) }
        
        guard ripeness >= 0.0 && ripeness <= 2.0 else {
            throw PomodorinoRipenessError.outOfRange(value: ripeness)
        }
        
        // Safely find the image and scale
        if let stage = growthStages.last(where: { $0.ripeness <= ripeness }) {
            return (stage.imageName, stage.scale)
        } else {
            throw PomodorinoRipenessError.noMatchingElement(value: ripeness)
        }
    }
}

