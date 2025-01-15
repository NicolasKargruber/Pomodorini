//
//  BreakView.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 25.11.24.
//

import SwiftUICore
import SwiftUI

/// A view that represents the break screen in the Pomodorino app.
///
/// The break screen allows users to view the ripening Pomodorino during a countdown
/// and collect it once the timer completes.
struct BreakView: View {
    // MARK: - Environment
    @Environment(\.presentationMode) private var presentationMode
    
    
    // MARK: - User Default Properties
    /// The total count of collected Pomodorini.
    @AppStorage("pomodorinoCount") var pomodorinoCount = 0

    // MARK: - Bindings
    /// A flag to indicate whether the timer should reset.
    @Binding var shouldResetTimer: Bool

    // MARK: - State
    /// The timer manager responsible for tracking the break timer.
    @State private var timerManager: TimerViewModel

    // MARK: - Initializer
    /// Initializes the `BreakView` with the specified duration and bindings.
    /// - Parameters:
    ///   - durationInMinutes: The duration of the break timer in minutes. Default is 5 minutes.
    ///   - pomodorinoCount: A binding to the current Pomodorino count.
    ///   - shouldResetTimer: A binding to the timer reset state.
    init(
        durationInMinutes: Int = 5,
        shouldResetTimer: Binding<Bool>
    ) {
        _shouldResetTimer = shouldResetTimer
        try! self.timerManager = TimerViewModel(
            totalMinutes: durationInMinutes, allowsOvertime: true)
    }

    // MARK: - Computed Properties
    /// Indicates whether the Pomodorino is ripe (timer has completed).
    private var isRipe: Bool {
        timerManager.isCompleted
    }

    /// Represents the ripeness of the Pomodorino as a value between 0.0 and 1.0.
    private var pomodorinoRipeness: Double {
        timerManager.progress
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            // MARK: Background
            BreakBackground()

            VStack(alignment: .trailing) {
                // MARK: Pomodorino Count
                PomodoriniButton()

                VStack(spacing: 30) {
                    
                    // MARK: Pomodorino Display
                    ZStack {
                        Capsule().fill(Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1))).opacity(0.5).frame(height: 260).padding(.horizontal)
                        
                        // Use the extracted SVGImage component
                        VStack (spacing: 30) {
                            PomodorinoStageView(ripeness: pomodorinoRipeness)
                            
                            // MARK: Collect Button
                            Button(action: collectPomodorino) {
                                Text("Collect").font(.title)
                            }
                            .disabled(!isRipe)
                            .buttonStyle(.bordered)
                            .tint(.white)
                            
                        }.padding()
                    }

                    // MARK: Timer Display
                    Text(!isRipe ? timerManager.formattedTime : timerManager.formattedOvertime)
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
        }
        .onAppear {
            UNUserNotificationCenter.current().setBadgeCount(0)
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    func startTimer() {
        timerManager.start()
        
        // Notification - Break
        NotificationManager.shared.scheduleNotification(
            title: "Pomodorino Done!",
            body: "Your Pomodorino has fully grown. Ready for another! 🌱",
            timeInterval: timerManager.remainingTime
        )
    }

    func stopTimer() {
        timerManager.stop()
    }
    
    // MARK: - Actions
    /// Handles the collection of a ripe Pomodorino.
    private func collectPomodorino() {
        timerManager.stop()
        pomodorinoCount += 1
        shouldResetTimer = true
        print("Send value of shouldResetTimer: \(shouldResetTimer)")
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Preview
#Preview {
    @Previewable @State var shouldResetTimer = false
    BreakView(
        durationInMinutes: 1,
        shouldResetTimer: $shouldResetTimer
    )
}
