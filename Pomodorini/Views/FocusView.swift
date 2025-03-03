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

    // Navigation
    // TODO: Handle when task changes and when Ending
    @State private var navigateToBreak: Bool = false
    @State private var doResetFocus = false
    
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
        self.vm = TimerViewModel(intervalDuration: durationInMinutes)
        pomodorino = Pomodorino.new(startTime: Date.now, setDuration: 25)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                background

                VStack {
                    PomodoriniButton()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 72) {
                        VStack(spacing: 12) {
                            goalButton
                            
                            TimerDisplay(formatedTime: vm.formattedTime, formatedOvertime: vm.formattedOvertime, showOvertime: vm.isCompleted)
                        }

                        // Focus Button
                        FocusButton(
                            state: vm.timerState,
                            onStart: { startFocusSession() },
                            onEnd: { endFocusSession() }
                        )
                        // Navigation
                        .navigationDestination(isPresented: $navigateToBreak) {
                            BreakView(shouldResetTimer: $doResetFocus)
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
        // Reset FocusView
        .onChange(of: doResetFocus, initial: false) { _, newValue in resetFocusSession() }
    }
    
    private func startFocusSession() {
        vm.startTimer()
        print("FocusView | Started Timer")
        
        // Notification - Focus
        NotificationManager.shared.scheduleNotification(
            title: "Pomodorino Ready!",
            body: "Your Pomodorino is almost done. Take a break! 🍅",
            timeInterval: vm.remainingTime
        )
        
        // Cancel Notifications when app dies
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { _ in
            // Terminating
            print("FocusView | App died")
            endFocusSession()
        }
    }
    
    private func endFocusSession() {
        vm.stopTimer()
        print("FocusView | Stopped Timer")
        
        // Navigation
        // TODO: Can be handled better - Use .ended
        if(pomodorino.hasTask) { showingSheet.toggle() }
        else { navigateToBreak = vm.hasEnded }
        
        // Remove notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("FocusView | Cancelled notifications")
    }
    
    private func resetFocusSession() {
        vm.resetTimer()
        print("FocusView | Resetted Timer")
        doResetFocus = false
    }
}

extension FocusView {
    private var background: some View {
        // Background Color
        PomodorinoGradient.gradient(forRipeness: vm.progress)
        .ignoresSafeArea()
        // Pomodorini Hat
        .overlay { Image("Pomodorini_Hat") .offset(x: 90, y: -320) }
    }
    
    private var goalButton: some View {
        Button(action: { showingSheet.toggle() }){
            Text((pomodorino.task?.label ?? "Goal")).font(.title).fontWeight(.semibold)
                .padding(.horizontal, 8).padding(.vertical, 4)
        }.buttonBorderShape(.roundedRectangle).buttonStyle(.bordered).tint(.primary)
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
