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

    var body: some View {
        content
    }

    @ViewBuilder
    private var content: some View {
        ZStack {
            if state == .notStarted {
                Button(action: {}) {
                    // Add if needed
                }.disabled(true).buttonStyle(.bordered)
            }
            
            if state == .running {
                skipButton
            }

            if state == .endable {
                collectButton
            }
        }
        .animation(.easeInOut(duration: 0.3), value: state) // ⬅️ Smooth transition
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
}

extension BreakButton {
    private var skipButton: some View {
        Button(action: onSkip) {
            Label("Skip", systemImage: "forward.end")
                .font(.title)
                .padding(.vertical, 4)
                .padding(.horizontal, 12)
        }
        .buttonStyle(.bordered)
        .tint(.primary)
        .cornerRadius(48)
        .transition(.opacity.combined(with: .scale))
    }
    
    private var collectButton: some View {
        Button(action: onCollect) {
            Text("Collect")
                .font(.largeTitle)
                .padding(.vertical, 4)
                .padding(.horizontal, 12)
        }
        .buttonStyle(.borderedProminent)
        .transition(.opacity.combined(with: .scale))
    }
}

#Preview {
    BreakButton(
        state: .notStarted, onSkip: {}, onCollect: {})
    
    Spacer().frame(height: 48)
    
    BreakButton(
        state: .running, onSkip: {}, onCollect: {})
    
    Spacer().frame(height: 48)
    
    BreakButton(
        state: .endable, onSkip: {}, onCollect: {})
}
