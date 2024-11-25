//
//  GradientColor.swift
//  HyperfocusBreaker
//
//  Created by Nicolas Kargruber on 18.11.24.
//


import SwiftUI

struct PomodoroGradient {
    let percentage: Double  // Wert zwischen 0 und 1
    
    init(at percentage: Double) {
        // Begrenze den Prozentwert auf den Bereich 0 bis 1
        self.percentage = max(0.0, min(percentage, 1.0))
    }
    
    func getColor() -> Color {
        Color(
            red: percentage * (1 - 0.3 * percentage),
            green: (1 - percentage) * (0.5 + 0.5 * percentage),
            blue: 0.0
        )
    }
}
