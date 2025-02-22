//
//  FocusButton.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 10.12.24.
//


import SwiftUI

struct FocusButton: View {
    // TODO: Fix with @AppStorage in -> POM-30
    @Binding var pomodorinoCount: Int
    @Binding var shouldResetTimer: Bool
    
    enum TimerState {
        case notStarted
        case running
        case finished
    }

    var state: TimerState
    var onStart: () -> Void
    var onNavigate: () -> Void

    // Animation
    @State private var buttonScale = 1.0
    private let animationDuration: TimeInterval = 0.3

    var body: some View {
        Button(action: { handleAction() }) { content }
        .frame(width: 70, height: 70)
        .foregroundColor(.primary)
        .background(.primary.opacity(0.3))
        .clipShape(Circle())
        .padding(3)
        .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 2))
        .scaleEffect(buttonScale)
        .onChange(of: state) { _, _ in updateScale() }
        .animation(.bouncy(duration: animationDuration), value: buttonScale)
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .notStarted:
            Text("Start")
        case .running:
            EmptyView()
        case .finished:
            NavigationLink(
                destination: BreakView(shouldResetTimer: $shouldResetTimer)
                    .navigationBarBackButtonHidden(true)) { Image(systemName: "apple.meditate").scaleEffect(1.5) }
                    .environment(\.colorScheme, .dark) // Enforce Dark-Mode
        }
    }

    private func handleAction() {
        switch state {
        case .notStarted:
            onStart()
        case .running:
            break // Add behavior for running if needed
        case .finished:
            onNavigate()
        }
    }

    // Animation
    private func updateScale() {
        switch state {
        case .notStarted:
            buttonScale = 1.0
        case .running:
            buttonScale = 0.4
        case .finished:
            buttonScale = 1.4
        }
    }
}

#Preview {
    @Previewable @State var pomodorinoCount = 0
    @Previewable @State var shouldResetTimer = false
    
    FocusButton(
        pomodorinoCount: $pomodorinoCount,
        shouldResetTimer: $shouldResetTimer,
        state: .notStarted, onStart: {}, onNavigate: {}).scaleEffect(1)
    
    FocusButton(
        pomodorinoCount: $pomodorinoCount,
        shouldResetTimer: $shouldResetTimer,
        state: .running, onStart: {}, onNavigate: {}).scaleEffect(0.4)
    
    FocusButton(
        pomodorinoCount: $pomodorinoCount,
        shouldResetTimer: $shouldResetTimer,
        state: .finished, onStart: {}, onNavigate: {}).scaleEffect(1.4)
}
