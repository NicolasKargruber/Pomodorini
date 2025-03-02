//
//  TimerView.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 17.11.24.
//

import ActivityKit
import SwiftUI
import SwiftData

/// A view that represents a Pomodorino timer screen.
struct FocusView: View {
    @AppStorage("pomodorinoCount") var pomodorinoCount = 0
    
    @State private var shouldResetTimer = false

    // Navigation
    // TODO: Handle when task changes and when Ending
    @State private var navigateToBreak: Bool = false
    
    // ViewModel
    @State var vm: TimerViewModel
    
    // SwiftData
    @Environment(\.modelContext) var modelContext
    @State var pomodorino: Pomodorino
    @Query var pomodorini: [Pomodorino]
    
    
    // Tarnsition Sheet
    @State private var showingSheet = false
    
    // Live Activity
    @State private var liveActivity: Activity<PomodorinoTimerAttributes>?
    
    init(durationInMinutes: Int = 25) {
        NotificationManager.shared.requestAuthorization ()
        self.vm = TimerViewModel(totalMinutes: durationInMinutes)
        pomodorino = Pomodorino.new(startTime: Date.now, setDuration: 25)
    }

    // TODO: Replace with Pomodorino.color()
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

                        // Focus Button
                        FocusButton(
                            state: vm.timerState,
                            onStart: { startTimer() },
                            onEnd: { endFocusSession() }
                        )
                        // Navigation
                        .navigationDestination(isPresented: $navigateToBreak) {
                            BreakView(shouldResetTimer: $shouldResetTimer)
                                .environment(\.colorScheme, .dark) // Enforce Dark-Mode
                                .navigationBarBackButtonHidden(true)
                        }
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
                if(vm.isRunning) { endFocusSession() }
            }
            .sheet(isPresented: $showingSheet) {
                TransitionSheetView(selectedTask: $pomodorino.task)
                    .onDisappear{ navigateToBreak = vm.hasEnded } // Navigation
            }
        }
        // TODO: Review - Reset View
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
            endFocusSession()
        }
    }
    
    private func endFocusSession() {
        vm.stop()
        print("Stopped Timer")
        
        // Navigation
        if(pomodorino.hasTask) { showingSheet.toggle() }
        // TODO: Create with timerState.ended
        else { navigateToBreak = vm.hasEnded }
        
        // Remove notifications
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
            Text((pomodorino.task?.label ?? "Goal")).font(.title)
                .padding(.horizontal, 8).padding(.vertical, 4)
        }
        .buttonBorderShape(.roundedRectangle).buttonStyle(.borderedProminent)
    }
}

#Preview {
    @Previewable @AppStorage("pomodorinoCount") var count = 0
    do {
        let previewer = try Previewer()
        return FocusView(durationInMinutes: 1).onAppear { count = 3 }
                .modelContainer(previewer.container)
        } catch {
            return Text("Failed to create preview: \(error.localizedDescription)")
        }
}
