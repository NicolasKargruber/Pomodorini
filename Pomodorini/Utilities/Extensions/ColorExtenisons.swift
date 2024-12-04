//
//  ColorExtenisons.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 04.12.24.
//

import SwiftUI

extension Color {
    static func interpolate(from startColor: UIColor, to endColor: UIColor, interpolationFactor: Double) -> Color {
        let startComponents = startColor.cgColor.components!
        let endComponents = endColor.cgColor.components!
        
        // Calculate interpolated RGB values
        let r = startComponents[0] + (endComponents[0] - startComponents[0]) * interpolationFactor
        let g = startComponents[1] + (endComponents[1] - startComponents[1]) * interpolationFactor
        let b = startComponents[2] + (endComponents[2] - startComponents[2]) * interpolationFactor
        
        return Color(red: r, green: g, blue: b)
    }
}

