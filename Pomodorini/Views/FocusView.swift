//
//  TimerView.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 17.11.24.
//

import SwiftUI

/// A view that represents a Pomodorino timer screen.
///
/// This screen allows the user to track their Pomodoro progress, displaying the timer,
/// a count of completed Pomodorini, and a button to manage the timer state.
struct FocusView: View {
    @AppStorage("pomodorinoCount") var pomodorinoCount = 0
    
    // FIXME: Make AppStorage in [POM-73]
    //@AppStorage("timerThreshold") var timerThreshold = 0.04/*%*/
    let timerThreshold: Double = 0.04/*%*/
    
    @State var vm: TimerViewModel
    @State private var shouldResetTimer = false
    
    init(durationInMinutes: Int = 25) {
        NotificationManager.shared.requestAuthorization ()
        self.vm = TimerViewModel(
            totalMinutes: durationInMinutes,threshold: timerThreshold, allowsOvertime: true)
    }

    /// Determines the color of the Pomodorino based on its ripeness.
    private var pomodorinoColor: Color {
        do {
            return try PomodorinoGradient.color(forRipeness: vm.progress)
        } catch {
            print("Error determining color: \(error)")
            return Color.black
        }
    }

    /// Determines the state of the timer button.
    private var timerButtonState: FocusButton.TimerState {
        if vm.isCompletable {
            return .finished
        } else if vm.isRunning {
            return .running
        } else {
            return .notStarted
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                background

                VStack {
                    PomodoriniButton()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // TODO: Refactor to new View in [POM-69]
                    VStack(spacing: 72) {
                        VStack(alignment: .trailing) {
                            goalDisplay
                            TimerDisplay(formatedTime: vm.formattedTime, formatedOvertime: vm.formattedOvertime, showOvertime: vm.isCompleted)
                        }
                        .frame(maxWidth: .infinity)

                        // Timer Button
                        FocusButton(
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
                // Reset Badge Count
                UNUserNotificationCenter.current().setBadgeCount(0)
                // Disable Screen Lock
                UIApplication.shared.isIdleTimerDisabled = true
            }
            .onDisappear {
                stopTimer()
            }
        }
        .onChange(of: vm.progress) { _, newValue in
            print("Pomodorino ripeness: \(newValue)")
        }
        .onChange(of: vm.isCompletable, initial: false) { _, newValue in
            print("Pomodorino is now pickable: \(newValue)")
        }
        /*.onChange(of: isRipe, initial: false) { _, newValue in
            print("Pomodorino is now ripe: \(newValue)")
        }*/
        .onChange(of: shouldResetTimer, initial: false) { _, newValue in
            print("Value changed of shouldResetTimer: \(shouldResetTimer)")
            if newValue {
                vm.reset()
                shouldResetTimer = false
            }
        }
    }
    
    private func startTimer() {
        vm.start()
        
        // Notification - Focus
        NotificationManager.shared.scheduleNotification(
            title: "Pomodorino Ready!",
            body: "Your Pomodorino is almost done. Take a break! 🍅",
            timeInterval: vm.remainingTime
        )
    }
    
    private func stopTimer() {
        vm.stop()
        
        // TODO: Not remove when app dies, but when new timer gets started
        //UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [UUID().uuidString])
    }
}

#Preview {
    @Previewable @AppStorage("pomodorinoCount") var count = 0
    FocusView(durationInMinutes: 1).onAppear { count = 3 }
}

extension FocusView {
    private var background: some View {
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
    
    // TODO: Delete
    private var goalDisplay: some View {
        Text("Goal: 25:00")
            .font(.system(size: 24, weight: .regular))
            .foregroundColor(.white)
            .padding(.horizontal, 72)
    }
}
