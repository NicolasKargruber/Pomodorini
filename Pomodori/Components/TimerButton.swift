//
//  BlueButton.swift
//  Pomodori
//
//  Created by Nicolas Kargruber on 25.11.24.
//

import SwiftUI


struct TimerButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 70, height: 70)
            .foregroundColor(Color(.white))
            .background(Color(.white).opacity(0.3))
            .buttonBorderShape(.circle)
            .padding(.all, 3)
            .overlay(
                Circle()
                    .stroke(Color(.white)
                    .opacity(0.3), lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
        
    }
}
