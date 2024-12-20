//
//  TimerView.swift
//  HyperfocusBreaker
//
//  Created by Nicolas Kargruber on 17.11.24.
//

import SwiftUI

/// A view that represents a Pomodorino timer screen.
///
/// This screen allows the user to track their Pomodoro progress, displaying the timer,
/// a count of completed Pomodorini, and a button to manage the timer state.
struct TimerView: View {
    // MARK: - User Default Properties
    
    /// The total count of collected Pomodorini.
    @AppStorage("pomodorinoCount") var pomodorinoCount = 0
    
    // FIXME: Make AppStorage in [POM-73]
    /// The timer threshold for Pomodorino ripeness.
    //@AppStorage("timerThreshold") var timerThreshold = 0.04/*%*/
    let timerThreshold: Double = 0.04/*%*/
    
    // MARK: - State Properties

    /// A flag to indicate whether the timer should reset.
    @State private var shouldResetTimer = false

    /// The timer manager responsible for tracking the countdown timer.
    @State var timerManager: TimerManager

    // MARK: - Initializer

    /// Initializes the `TimerView` with a specified duration.
    /// - Parameter durationInMinutes: The duration of the timer in minutes. Default is 25 minutes.
    init(durationInMinutes: Int = 25) {
        NotificationManager.shared.requestAuthorization ()
        self.timerManager = TimerManager(
            totalMinutes: durationInMinutes,threshold: timerThreshold, allowsOvertime: true)
    }

    // MARK: - Computed Properties

    /// Indicates whether the timer is currently running.
    private var isGrowing: Bool {
        timerManager.isRunning
    }

    /// Indicates whether the Pomodorino is pickable (timer is stoppable).
    private var isPickable: Bool {
        timerManager.isCompletable
    }

    /// Indicates whether the Pomodorino is ripe (timer has completed).
    private var isRipe: Bool {
        timerManager.isCompleted
    }

    /// Represents the ripeness of the Pomodorino, as a value from 0.0 to 2.0.
    private var pomodorinoRipeness: Double {
        timerManager.progress
    }

    /// Determines the color of the Pomodorino based on its ripeness.
    private var pomodorinoColor: Color {
        do {
            return try PomodorinoGradient.color(forRipeness: pomodorinoRipeness)
        } catch {
            print("Error determining color: \(error)")
            return Color.black
        }
    }

    /// Determines the state of the timer button.
    private var timerButtonState: TimerButton.TimerState {
        if isPickable {
            return .finished
        } else if isGrowing {
            return .running
        } else {
            return .notStarted
        }
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // MARK: Background
                createBackground()

                // MARK: Content
                VStack {
                    // Pomodorino Count Display
                    Button("\(pomodorinoCount) 🍅") {}
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .buttonStyle(.bordered)
                        .tint(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // TODO: Refactor to new View in [POM-69]
                    VStack {
                        VStack(alignment: .trailing) {
                            // Goal Display
                            Text("Goal: 25:00")
                                .font(.system(size: 24, weight: .regular))
                                .foregroundColor(.white)
                                .padding(.horizontal, 72)

                            // Timer Display
                            Text(!isRipe ? timerManager.formattedTime : timerManager.formattedOvertime)
                                .font(.system(size: 80, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)

                        // Timer Button
                        TimerButton(
                            pomodorinoCount: $pomodorinoCount,
                            shouldResetTimer: $shouldResetTimer,
                            state: timerButtonState,
                            onStart: { startTimer() },
                            onNavigate: { } // Won't respond due to NavigationLink
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
            .onAppear    {
                UNUserNotificationCenter.current().setBadgeCount(0)
            }
            .onDisappear {
                stopTimer()
            }
        }
        .onChange(of: pomodorinoRipeness) { _, newValue in
            print("Pomodorino ripeness: \(newValue)")
        }
        .onChange(of: isPickable, initial: false) { _, newValue in
            print("Pomodorino is now pickable: \(newValue)")
        }
        /*.onChange(of: isRipe, initial: false) { _, newValue in
            print("Pomodorino is now ripe: \(newValue)")
        }*/
        .onChange(of: shouldResetTimer, initial: false) { _, newValue in
            print("Value changed of shouldResetTimer: \(shouldResetTimer)")
            if newValue {
                timerManager.reset()
                shouldResetTimer = false
            }
        }
    }
    
    private func startTimer() {
        timerManager.start()
        
        // Notification
        NotificationManager.shared.scheduleNotification(
            title: "Pomodorino Ready!",
            body: "Your Pomodorino is almost done. Take a break! 🍅",
            timeInterval: timerManager.remainingTime
        )
    }
    
    private func stopTimer() {
        timerManager.stop()
        
        // TODO: Remove when app dies
        //UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [UUID().uuidString])
    }
    
    // MARK: - Actions
    /// Creates background image.
    private func createBackground() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [
                pomodorinoColor,
                pomodorinoColor.mix(with: Color.black, by: 0.35)
            ]),
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        )
        .ignoresSafeArea()
        .overlay {
            Image("Pomodorini_Hat")
                .offset(x: 90, y: -320)
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @AppStorage("pomodorinoCount") var count = 0
    TimerView(durationInMinutes: 1).onAppear { count = 3 }
}
