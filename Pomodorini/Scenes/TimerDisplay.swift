//
//  TimerDisplay.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 22.12.24.
//

import SwiftUI

struct TimerDisplay: View {
    var formatedTime: String
    var formatedOvertime: String
    var showOvertime: Bool
    
    /// The scale value for animation.
    @State private var overtimeScale = 0.0
    
    var body: some View {
        VStack {
            Text(formatedTime)
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(.white)
            
            
            // Timer Display
            if showOvertime {
                Text(formatedOvertime)
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(.white).opacity(0.7)
                    .padding(.horizontal, 84)
                    .scaleEffect(overtimeScale)
                    // Animation
                    .transition( .asymmetric(insertion: .scale, removal: .opacity) )
                    .onAppear { withAnimation { overtimeScale = 1 } }
            }
        }.frame(maxWidth: .infinity)
    }
}

#Preview {
    TimerDisplay(formatedTime: "00:00", formatedOvertime: "+00:00", showOvertime: true)
}
