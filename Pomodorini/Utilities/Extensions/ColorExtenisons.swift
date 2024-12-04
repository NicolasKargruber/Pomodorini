//
//  ColorExtenisons.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 04.12.24.
//

import SwiftUI

extension Color {
    static func interpolate(from: UIColor, to: UIColor, fraction: Double) -> Color {
        let fromComponents = from.cgColor.components!
        let toComponents = to.cgColor.components!
        
        //print(fromComponents, toComponents, fraction)
        
        // Calculate interpolated RGB values
        let r = fromComponents[0] + (toComponents[0] - fromComponents[0]) * fraction
        let g = fromComponents[1] + (toComponents[1] - fromComponents[1]) * fraction
        let b = fromComponents[2] + (toComponents[2] - fromComponents[2]) * fraction
        
        return Color(red: r, green: g, blue: b)
    }
}
