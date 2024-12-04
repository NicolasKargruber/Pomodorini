//
//  GradientColor.swift
//  HyperfocusBreaker
//
//  Created by Nicolas Kargruber on 18.11.24.
//


import SwiftUI

struct PomodorinoGradient {
        // Hardcoded colors with percentage ranges (0% to 200% example)
        static let colorStops: [(percentage: Double, color: UIColor)] = [
            (0.00, #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),        // 0%
            //(0.25, #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),        // 25%
            (0.30, #colorLiteral(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1)),       // 50%
            (0.60, #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)),   // 75%
            (0.96, #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)), // 96%
            (1.04, #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)), // 104%
            (1.20, #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)), // 100%
            (1.50, #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1))    // Above 100%, extra range if needed
        ]
    
        // Function to get color for a given percentage
        static func color(for percentage: Double) throws -> Color {
            guard percentage >= 0.0 && percentage <= 2.0
            else {
                throw ColorError.invalidPercentage(value: percentage)
            }
            
            // Upper Color
            let (index, upper) = colorStops.enumerated().first(where: {$0.1.percentage >= percentage})!
            
            // Lower Color
            let lower = (index > 0) ? colorStops[index - 1] : upper
            
            // Fraction
            // (Handle division by ZERO case)
            let fraction = upper.percentage - lower.percentage != 0 ?
                (percentage - lower.percentage) / (upper.percentage - lower.percentage) : 0.0
            
            print(percentage, lower.percentage, upper.percentage, fraction)

            // Interpolated color
            return Color.interpolate(from: lower.color, to: upper.color, fraction: fraction)
        }
}
