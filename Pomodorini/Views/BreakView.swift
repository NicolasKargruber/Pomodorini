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
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("pomodorinoCount") var pomodorinoCount = 0

    @Binding var shouldResetTimer: Bool

    @State private var vm: TimerViewModel

    init(durationInMinutes: Int = 5, shouldResetTimer: Binding<Bool>) {
        _shouldResetTimer = shouldResetTimer
        self.vm = TimerViewModel(totalMinutes: durationInMinutes)
    }

    var body: some View {
        ZStack {
            Background()
            
            VStack(alignment: .trailing) {
                PomodoriniButton()
                
                VStack(spacing: 30) {
                    growingPomodorino
                    TimerDisplay(formatedTime: vm.formattedTime, formatedOvertime: vm.formattedOvertime, showOvertime: vm.isCompleted)
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
        vm.start()
        
        // Notification - Break
        NotificationManager.shared.scheduleNotification(
            title: "Pomodorino Done!",
            body: "Your Pomodorino has fully grown. Ready for another! 🌱",
            timeInterval: vm.remainingTime
        )
        
        // Cancel Notifications when app dies
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { _ in
            // Terminating
            print("App died")
            stopTimer()
        }
    }

    func stopTimer() {
        vm.stop()
        print("Stopped Timer")
        
        // Remove notifications when timer stops before
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("Cancelled notifications")
   }
    
    private func collectPomodorino() {
        vm.stop()
        pomodorinoCount += 1
        shouldResetTimer = true
        print("Send value of shouldResetTimer: \(shouldResetTimer)")
        dismiss()
    }
}

extension BreakView {
    
    struct Background: View {
        @State private var isAnimating = false
        
        var body: some View {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)),
                    Color(#colorLiteral(red: 0.107204847, green: 0.107204847, blue: 0.107204847, alpha: 1))
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .overlay {
                Ellipse()
                    .fill(Color(#colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)).opacity(0.3))
                    .frame(width: UIScreen.main.bounds.width * 2, height: 300)
                    .offset(y: 450)
                
                
                    Ellipse()
                        .fill(Color(#colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)).opacity(0.3))
                        .frame(width: UIScreen.main.bounds.width * 2, height: 600)
                        .offset(y: 660)

                Circle()
                    .fill(Color(#colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)).opacity(0.8))
                    .frame(width: 330, height: 330)
                    .scaleEffect(isAnimating ? 1.1 : 1)
                    .animation(
                      isAnimating ?
                        .easeInOut(duration: 2.25).repeatForever(autoreverses: true) :
                        .default,
                      value: isAnimating
                    )
                    .offset(x: -200, y: -460)
                    .onAppear {
                        isAnimating = true
                      }
                
                Circle()
                    .fill(Color(#colorLiteral(red: 0.9978314042, green: 0.7260366082, blue: 0.07187078148, alpha: 1)).opacity(0.8))
                    .frame(width: 275, height: 275)
                    .scaleEffect(isAnimating ? 1.1 : 1)
                    .animation(
                      isAnimating ?
                        .easeInOut(duration: 2).repeatForever(autoreverses: true) :
                        .default,
                      value: isAnimating
                    )
                    .offset(x: -200, y: -460)
            }
        }
    }
    
    // TODO: Refactor this View
    private var growingPomodorino: some View {
        VStack (spacing: 30) {
            // SVGImage
            PomodorinoStageView(ripeness: vm.progress)
            
            BreakButton(state: vm.timerState, onSkip: {}, onCollect: collectPomodorino)
            
        }.padding()
    }
}

#Preview {
    @Previewable @State var shouldResetTimer = false
    BreakView(
        durationInMinutes: 1,
        shouldResetTimer: $shouldResetTimer
    )
}
