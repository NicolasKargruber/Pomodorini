//
//  FocusButton.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 10.12.24.
//


import SwiftUI

struct BreakButton: View {
    var state: PomodorinoTimerState
    var onSkip: () -> Void
    var onCollect: () -> Void

    // Animation
    @State private var buttonScale = 1.0
    private let animationDuration: TimeInterval = 0.3

    var body: some View {
        content
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .notStarted:
            Button(action: {}) {
                Text("Collect").font(.title)
            }
            .disabled(true)
            .buttonStyle(.bordered)
            .tint(.white)
        case .running:
            Button(action: onSkip) {
                Text("Collect").font(.title)
            }
            .disabled(true)
            .buttonStyle(.bordered)
            .tint(.white)
        case .endable:
            Button(action: onCollect) {
                Text("Collect").font(.title)
            }
            .disabled(false)
            .buttonStyle(.bordered)
            .tint(.white)
        }
    }

    private func handleAction() {
        switch state {
        case .notStarted:
            break // Add behavior for notStarted if needed
        case .running:
            onSkip()
        case .endable:
            onCollect()
        }
    }

    // Animation
    private func updateScale() {
        switch state {
        case .notStarted:
            buttonScale = 1.0
        case .running:
            buttonScale = 0.4
        case .endable:
            buttonScale = 1.4
        }
    }
}

#Preview {
    @Previewable @State var pomodorinoCount = 0
    @Previewable @State var shouldResetTimer = false
    
    BreakButton(
        state: .notStarted, onSkip: {}, onCollect: {})
    
    Spacer().frame(height: 48)
    
    BreakButton(
        state: .running, onSkip: {}, onCollect: {})
    
    Spacer().frame(height: 48)
    
    BreakButton(
        state: .endable, onSkip: {}, onCollect: {})
}
