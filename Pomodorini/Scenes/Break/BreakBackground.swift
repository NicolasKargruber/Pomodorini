//
//  BreakBackground.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 11.12.24.
//

import SwiftUICore
import UIKit


struct BreakBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(#colorLiteral(red: 0.584, green: 0.824, blue: 0.420, alpha: 1)),
                Color(#colorLiteral(red: 0.030, green: 0.352, blue: 0.026, alpha: 1))
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .overlay {
            Ellipse()
                .fill(Color.white.opacity(0.1))
                .frame(width: UIScreen.main.bounds.width * 2, height: 300)
                .offset(y: 430)

            Circle()
                .fill(Color.white.opacity(0.3))
                .frame(width: 400, height: 400)
                .offset(x: -200, y: -460)
        }
    }
}
