//
//  SVGImage.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 20.12.24.
//


import SwiftUI

/// A view that displays the Pomodorino image with animation and scaling based on its ripeness.
struct PomodorinoStageView: View {
    let ripeness: Double
    let animationDuration: Double = 1.8
    
    private var imageInfo: (imageName: String, scale: CGFloat) {
            do {
                return try PomodorinoGrowth.imageInfo(forRipeness: ripeness)
            } catch {
                print("Error determining image and scale: \(error)")
                return ("", 1.0) // Fallback to a default value
            }
        }
    
    var body: some View {
            Image(imageInfo.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(imageInfo.scale)  // Use scale from PomodorinoGrowth
                .frame(width: 100, height: 100)
                .animation(.snappy(duration: animationDuration), value: imageInfo.imageName)
                .transition(.opacity)
        }
}
