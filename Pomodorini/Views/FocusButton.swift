//
//  FocusButton.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 10.12.24.
//


import SwiftUI

struct FocusButton: View {
    var state: PomodorinoTimerState
    var onStart: () -> Void
    var onEnd: () -> Void
    var onReset: () -> Void
    
    // Animation
    @State var isTapped: Bool = false
    @State var isLongPressed: Bool = false

    // Animation
    @State private var buttonScale = 1.0
    private let animationDuration: TimeInterval = 0.3
    
    // Fix onReset() Bug
    @State var updateScaleOnTaskEnd: Bool = false

    var body: some View {
        VStack(spacing: 24) {
            // Focus
            Button(action: { handleAction() }) { content }
                .frame(width: 70, height: 70)
                .foregroundColor(.white)
                .background(.white.opacity(0.3))
                .clipShape(Circle())
                .padding(3)
                .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 2))
                .scaleEffect(buttonScale)
                .onChange(of: state) { _, _ in
                    updateScale()
                    updateScaleOnTaskEnd = false
                }
                .animation(.bouncy(duration: animationDuration), value: buttonScale)
            
            // Reset
            if(isTapped) {
                Button(action: onReset){ Image(systemName: "arrow.counterclockwise") }
                .frame(width: 48, height: 48)
                .foregroundColor(.white).background(.white.opacity(0.3)).clipShape(Circle())
                .transition(.move(edge: .top))
            }
        }.frame(height: 132, alignment: .top)
        .onAppear(){ updateScale() } // For Preview
    }

    @ViewBuilder
    private var content: some View {
        // Content
        Group {
            switch state {
            case .notStarted:
                Text("Start")
            case .running:
                if(isTapped){
                        navigationButton.task(delayShrink)
                     }
                else { invisibleView }
            case .endable:
                navigationButton
            case .ended:
                navigationButton
            }
        } // Handle Long Press
        .onLongPressGesture(minimumDuration: 3, perform: {}, onPressingChanged: { (isPressed) in
            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                impactHeavy.impactOccurred()
            if(isPressed){
                print("Focus Button | long press")
                isLongPressed = true
                updateScale()
            } else {
                print("Focus Button | is let go")
                isLongPressed = false
                updateScale()
            }
        })
    }

    private func handleAction() {
        // Haptic Feedback
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
        impactMed.impactOccurred()
        
        // Action
        switch state {
        case .notStarted:
            onStart()
        case .running:
            break // Add behavior for running if needed
        case .endable:
            // onEnd() -> // Handled in Button Content
            break
        case .ended:
            // onEnd() -> // Handled in Button Content
            break
        }
    }

    // Animation
    private func updateScale() {
        if(isLongPressed) { return buttonScale = 1.2 }
        switch state {
        case .notStarted:
            buttonScale = 1.0
        case .running:
            if(isTapped) { buttonScale = 1.4 }
            else { buttonScale = 0.4 }
        case .endable:
            buttonScale = 1.4
        case .ended:
            buttonScale = 1.4
        }
    }
}

extension FocusButton {
    private var invisibleView: some View {
        Circle().opacity(0.01)
            .onTapGesture {
                print("Focus Button | was tapped")
                withAnimation{
                    isTapped = true
                }
                updateScale()
           }
    }
    
    // Shrinks button back down after X seconds
    @Sendable private func delayShrink() async {
        updateScaleOnTaskEnd = true
        try? await Task.sleep(for: .seconds(4))
        isTapped = false
        // Update if state unchanged
        if(updateScaleOnTaskEnd) { updateScale() }
    }
    
    private var navigationButton: some View {
        Image(systemName: "apple.meditate").scaleEffect(1.5)
            .onTapGesture{ onEnd() }
    }
}

#Preview {
    @Previewable @State var pomodorinoCount = 0
    @Previewable @State var shouldResetTimer = false
    
    ZStack {
        Color.black.frame(width: .infinity, height: .infinity).ignoresSafeArea()
        
        VStack {
            FocusButton(
                state: .notStarted, onStart: {}, onEnd: {}, onReset: {})
            
            Spacer().frame(height: 48)
            
            FocusButton(
                state: .running, onStart: {}, onEnd: {}, onReset: {})
            
            Spacer().frame(height: 48)
            
            FocusButton(
                state: .endable, onStart: {}, onEnd: {}, onReset: {})
        }
    }
}
