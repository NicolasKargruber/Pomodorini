//
//  TimerView.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 17.11.24.
//

import ActivityKit
import SwiftUI

/// A view that represents a Pomodorino timer screen.
struct FocusView: View {
    @AppStorage("pomodorinoCount") var pomodorinoCount = 0
    
    @State var pomodorinoTask: PomodorinoTask? = nil
    
    @State var vm: TimerViewModel
    @State private var shouldResetTimer = false
    
    // Tarnsition Sheet
    @State private var showingSheet = false
    
    // Live Activity
    @State private var liveActivity: Activity<PomodorinoTimerAttributes>?
    
    init(durationInMinutes: Int = 25) {
        NotificationManager.shared.requestAuthorization ()
        self.vm = TimerViewModel(totalMinutes: durationInMinutes)
    }

    /// Determines the color of the Pomodorino based on its ripeness.
    private var pomodorinoColor: Color {
        do {
            let color = try PomodorinoGradient.color(forRipeness: vm.progress)
            return color
        } catch {
            print("Failed to determine Pomodorino color: \(error)")
            print("Defaulting to black.")
            return .black
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                background

                VStack {
                    PomodoriniButton()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 72) {
                        VStack(spacing: 8) {
                            goalButton
                            
                            TimerDisplay(formatedTime: vm.formattedTime, formatedOvertime: vm.formattedOvertime, showOvertime: vm.isCompleted)
                        }

                        // Timer Button
                        FocusButton(
                            pomodorinoCount: $pomodorinoCount,
                            shouldResetTimer: $shouldResetTimer,
                            state: vm.timerState,
                            onStart: { startTimer() },
                            onEnd: { } // Won't respond due to NavigationLink
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
            .sheet(isPresented: $showingSheet) {
                TransitionSheetView(task: $pomodorinoTask)
            }
        }
        .onChange(of: vm.isEndable, initial: false) { _, newValue in
            print("Pomodorino is now pickable: \(newValue)")
        }
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
        
        // Cancel Notifications when app dies
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { _ in
            // Terminating
            print("App died")
            stopTimer()
        }
    }
    
    private func stopTimer() {
        vm.stop()
        print("Stopped Timer")
        
        // Remove notifications when timer stops before
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("Cancelled notifications")
    }
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
    
    private var goalButton: some View {
        Button(action: { showingSheet.toggle() })
        {
            Text("Goal").font(.title)
                .padding(.horizontal, 8).padding(.vertical, 4)
        }
        .buttonBorderShape(.roundedRectangle).buttonStyle(.borderedProminent)
    }
}

#Preview {
    @Previewable @AppStorage("pomodorinoCount") var count = 0
    FocusView(durationInMinutes: 1).onAppear { count = 3 }
}
