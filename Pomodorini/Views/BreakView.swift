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
    @Environment(\.presentationMode) private var presentationMode
    
    @AppStorage("pomodorinoCount") var pomodorinoCount = 0

    @Binding var shouldResetTimer: Bool

    @State private var vm: TimerViewModel

    init(durationInMinutes: Int = 5, shouldResetTimer: Binding<Bool>) {
        _shouldResetTimer = shouldResetTimer
        self.vm = TimerViewModel(
            totalMinutes: durationInMinutes, allowsOvertime: true)
    }

    var body: some View {
        ZStack {
            background
            
            VStack(alignment: .trailing) {
                PomodoriniButton()
                
                VStack(spacing: 30) {
                    growingPomodorino
                    timerDisplay
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
    }

    func stopTimer() {
        vm.stop()
        
        // TODO: Not remove when app dies, but when new timer gets started
        //UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [UUID().uuidString])
   }
    
    private func collectPomodorino() {
        vm.stop()
        pomodorinoCount += 1
        shouldResetTimer = true
        print("Send value of shouldResetTimer: \(shouldResetTimer)")
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    @Previewable @State var shouldResetTimer = false
    BreakView(
        durationInMinutes: 1,
        shouldResetTimer: $shouldResetTimer
    )
}

extension BreakView {
    private var background: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(#colorLiteral(red: 0.584, green: 0.824, blue: 0.420, alpha: 1)),
                Color(#colorLiteral(red: 0.030, green: 0.352, blue: 0.026, alpha: 1))
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .overlay {
            Ellipse()
                .fill(Color.white.opacity(0.1))
                .frame(width: UIScreen.main.bounds.width * 2, height: 300)
                .offset(y: 430)

            Circle()
                .fill(Color.white.opacity(0.3))
                .frame(width: 400, height: 400)
                .offset(x: -200, y: -460)
        }
    }
    
    
    private var growingPomodorino: some View {
        ZStack {
            Capsule().fill(Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1))).opacity(0.5).frame(height: 260).padding(.horizontal)
            
            VStack (spacing: 30) {
                // SVGImage
                PomodorinoStageView(ripeness: vm.progress)
                
                // Collect Button
                Button(action: collectPomodorino) {
                    Text("Collect").font(.title)
                }
                .disabled(!vm.isCompleted)
                .buttonStyle(.bordered)
                .tint(.white)
                
            }.padding()
        }
    }
    
    private var timerDisplay: some View {
        Text(!vm.isCompleted ? vm.formattedTime : vm.formattedOvertime)
            .font(.system(size: 80, weight: .bold))
            .foregroundColor(.white)
    }
}
