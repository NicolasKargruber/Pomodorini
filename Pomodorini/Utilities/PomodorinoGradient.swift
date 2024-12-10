//
//  PomodorinoGradient.swift
//  HyperfocusBreaker
//
//  Created by Nicolas Kargruber on 18.11.24.
//


import SwiftUI

struct PomodorinoGradient {
    // Hardcoded color stops with percentage positions (0% to 200% example)
    static let colorStops: [(position: Double, color: UIColor)] = [
        (0.00, #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),        // 0%
        //(0.25, #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),        // 25%
        (0.30, #colorLiteral(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1)),       // 50%
        (0.60, #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)),   // 75%
        (0.96, #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)), // 96%
        (1.04, #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)), // 104%
        (1.20, #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)), // 100%
        (1.50, #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1))    // Above 100%, extra range if needed
    ]
    
    // Function to get color for a given percentage position
    static func color(for position: Double) throws -> Color {
        guard position >= 0.0 && position <= 2.0
        else {
            throw PomodorinoRipenessError.outOfRange(value: position)
        }
        
        // Safely find the upper bound stop
        guard let (index, endStop) = colorStops.enumerated().first(where: { $0.1.position >= position }) else {
            throw PomodorinoRipenessError.noMatchingElement(value: position)
        }
        
        // Find the lower bound stop
        let startStop = (index > 0) ? colorStops[index - 1] : endStop
        
        // Fraction for interpolation
        let factor = endStop.position - startStop.position != 0 ?
            (position - startStop.position) / (endStop.position - startStop.position) : 0.0
        
        // TODO: Delete
        // print(position, startStop.position, endStop.position, factor)
        
        // Interpolated color
        return Color.interpolate(from: startStop.color, to: endStop.color, interpolationFactor: factor)
    }
}
