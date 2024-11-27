//
//  GradientColor.swift
//  HyperfocusBreaker
//
//  Created by Nicolas Kargruber on 18.11.24.
//


import SwiftUI

struct PomodoroGrowth {
    let percentage: Double  // Wert zwischen 0 und 1
    let defaultSize: Double =  0.15 // 25
    let defaultGrowth: Double = 0.15 // 25
    
    init(at percentage: Double) {
        // Begrenze den Prozentwert auf den Bereich 0 bis 1.5
        self.percentage = max(0.0, min(percentage, 1.5))
    }
    
    func getSize() -> Double {
        defaultSize + defaultGrowth * percentage
    }
}
