//
//  FocusView.swift
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
    var lastPomodorino: Pomodorino? {
        return pomodorini.sorted(by: {$0.startTime < $1.startTime}).last
    }
    
    // Awareness Message
    @State private var showingFriendlyReminder: Bool = false
    @State private var awarenessMessage: String = AwarenessMessage.random()
    
    // Confirmation Dialog
    @State private var showingConfirmation: Bool = false
    
    // Transition Sheet
    @State private var showingSheet = false
    
    // Live Activity
    @State private var liveActivity: Activity<PomodorinoTimerAttributes>?
    
    // MARK: - Init
    init(durationInMinutes: Int = 25) {
        NotificationManager.shared.requestAuthorization ()
        self.vm = TimerViewModel(intervalDuration: durationInMinutes)
        
        // Create new Pomdorino
        pomodorino = Pomodorino.new(startTime: Date.now, intervalDuration: durationInMinutes)
        // TODO: will not work on App open, Fix in POM-114
        //pomodorino.task = lastPomodorino?.task
        print("FocusView | Create  new Pomodorino")
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                background

                VStack {
                    HStack {
                        PomodoriniButton()
                        Spacer()
                        // Navigation to History
                        HistoryView.navigationButton
                    }

                    VStack(spacing: 48) {
                        Spacer().frame(height: 140)
                        
                        VStack(spacing: 12) {
                            goalButton
                            
                            TimerDisplay(
                                formatedTime: vm.formattedTime,
                                formatedOvertime: vm.formattedOvertime,
                                showOvertime: vm.isCompleted
                            ).scaleEffect(pomodorino.hasTask ? 0.8 : 1)
                        }

                        // Focus Button
                        focusButton
                        
                        Spacer()
                        
                        if showingFriendlyReminder { awarenessMessageView }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
            .onAppear    {
                // Remove local Notificaions
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                // Reset Badge Count
                UNUserNotificationCenter.current().setBadgeCount(0)
                // Disable Screen Lock
                UIApplication.shared.isIdleTimerDisabled = true
            }
            .sheet(isPresented: $showingSheet) {
                TransitionSheetView(selectedTask: $pomodorino.task, timerState: vm.timerState)
                    .onDisappear{ navigateToBreak = vm.hasEnded } // Navigation to BREAK VIEW
            }
        }
        // Reset FocusView
        .onChange(of: doResetFocus, initial: false) { _, newValue in resetFocusSession() }
        // Toggle Awareness Messages
        .onChange(of: vm.isTimeForAwareness) { _, newValue in
            withAnimation {
                showingFriendlyReminder = newValue
                awarenessMessage = AwarenessMessage.random()
            }
        }
    }
    
    private func startFocusSession() {
        vm.startTimer()
        print("FocusView | Started Timer")
        
        // ADD Pomodorino
        pomodorino.startTime = vm.startTime ?? Date.now
        modelContext.insert(pomodorino)
        print("FocusView | Added new Pomodorino")
        
        // Live Activity - Start
        LiveActivityManager.shared
            .startActivity(timerInterval: vm.timerInterval, taskLabel: pomodorino.task?.label)
        print("FocusView | Started Live Activity")
        
        // Notification - Focus
        NotificationManager.shared.scheduleNotification(
            title: "Pomodorino Ready!",
            body: "Your Pomodorino is almost done. Take a break! 🍅",
            timeInterval: vm.remainingTime
        )
        
        // Cancel Notifications when App dies
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { _ in
            // Terminating
            print("FocusView | App died")
            endFocusSession(savePomodorino: false)
        }
    }
    
    private func endFocusSession(savePomodorino: Bool = true) {
        vm.stopTimer()
        print("FocusView | Stopped Timer")
        
        if(savePomodorino && vm.ranMoreThan1Minute) {
            // Save Pomodorino
            // pomodorino.startTime = vm.startTime ?? Date.now // Is redundant
            pomodorino.endTime = vm.endTime
            print("FocusView | Saved Pomodorino EndTime")
        }
        else {
            // Remove Pomodorino
            modelContext.delete(pomodorino)
            print("FocusView | Removed Pomodorino")
        }
        
        // Live Activity - End
        LiveActivityManager.shared.endActivity(timerInterval: vm.timerInterval)
        
        // Navigation
        // TODO: Can be handled better - Use .ended
        if(pomodorino.hasTask) { showingSheet.toggle() }
        else { navigateToBreak = vm.hasEnded }
        
        // Remove notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("FocusView | Cancelled notifications")
    }
    
    private func resetFocusSession(showSheet: Bool = true) {
        vm.resetTimer()
        print("FocusView | Resetted Timer")
        
        // Create new Pomodorino
        pomodorino = Pomodorino.new(startTime: Date.now, intervalDuration: 25)
        print("FocusView | Resetted with new Pomodorino")
        
        // Update with previous Task
        if let previousTask = lastPomodorino?.task, !previousTask.isDone {
            pomodorino.task = lastPomodorino?.task
        }
        
        // Sheet
        if(showSheet && pomodorino.hasTask) {
            showingSheet = true
            print("FocusView | Updated with previous Task: \(pomodorino.task?.label ?? "")")
        }
        
        doResetFocus = false
    }
}

// MARK: - Extension
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
        }.buttonBorderShape(.roundedRectangle).buttonStyle(.bordered).tint(.white)
            .scaleEffect(pomodorino.hasTask ? 1.2 : 1)
    }
    
    private var focusButton: some View {
        FocusButton(
            state: vm.timerState,
            onStart: { startFocusSession() },
            onEnd: {
                if(vm.ranMoreThan1Minute) { endFocusSession() }
                else { showingConfirmation = true }
            },
            onReset: { resetFocusSession(showSheet: false) }
        )
        // Confirmation
        .confirmationDialog("End Focus", isPresented: $showingConfirmation) {
            Button("End", role: .destructive) { endFocusSession() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Focus Sessions under 1 Minute will not\nshow in your History.\n\nEnd Pomodorino?")
        }
        // Navigation to BREAK VIEW
        .navigationDestination(isPresented: $navigateToBreak) {
            BreakView(doResetFocus: $doResetFocus)
                .environment(\.colorScheme, .dark) // Enforce Dark-Mode
                .navigationBarBackButtonHidden(true)
        }
    }
    
    private var awarenessMessageView: some View {
        Text(awarenessMessage)
            .font(.title2).multilineTextAlignment(.center)
            .foregroundColor(PomodorinoGradient.color(forRipeness: vm.progress).mix(with: .white, by: 0.6))
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            .padding(.horizontal, 36)
    }
}

// MARK: - Preview
#Preview {
    @Previewable @AppStorage("pomodorinoCount") var count = 0
    let pomodorinoTask = PomodorinoTask.newTask(named: "Geoguessr 🌍")
    let durationInSeconds = 30
    
    FocusView(durationInMinutes: durationInSeconds).onAppear { count = 3 }
            .attachPreviewContainerWith(pomodorinoTasks: [pomodorinoTask])
}
