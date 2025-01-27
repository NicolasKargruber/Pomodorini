//
//  PomodoriniButton.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 22.12.24.
//

import SwiftUI

struct PomodoriniButton: View {
    /// The total count of collected Pomodorini.
    @AppStorage("pomodorinoCount") var pomodorinoCount = 0
    
    var body: some View {
        Button("\(pomodorinoCount) 🍅", action: {})
            .simultaneousGesture(
                LongPressGesture().onEnded { _ in pomodorinoCount = 0 }
            )
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .buttonStyle(.bordered)
            .tint(.white)
    }
}

#Preview {
    PomodoriniButton()
}
