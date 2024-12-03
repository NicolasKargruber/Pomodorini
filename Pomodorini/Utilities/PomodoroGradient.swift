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
        // Begrenze den Prozentwert auf den Bereich 0 bis 1.5
        self.percentage = max(0.0, min(percentage, 1.5))
    }
    
    func getColor() -> Color {
        // [Green: r:1, g:0.5, b:0]
        // [Red: r:1, g:0.5, b:0]
        
        // TODO: Use the following colors (Interpolation)
        #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1);#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1);#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1);#colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1);
        
        if (0 <= percentage && percentage <= 1) {
            return Color(
                red: percentage * (1 - 0.3 * percentage),
                green: (1 - percentage) * (0.5 + 0.5 * percentage),
                blue: 0.0)
        }
        else if (1 < percentage && percentage < 2) {
            return Color(
                red: (0.7 - (percentage-1) * 0.5),
                green: (0.5 - (percentage-1) * 0.4),
                blue: 0.0)
        }
        else {
            return Color(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051)
            #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)
        }
    }
}
