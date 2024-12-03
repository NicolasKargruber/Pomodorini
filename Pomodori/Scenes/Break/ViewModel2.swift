//
//  ViewModel.swift
//  Pomodori
//
//  Created by Nicolas Kargruber on 25.11.24.
//

import SwiftUICore

extension BreakView {
    @Observable
    class ViewModel2 {
        let pomodoro: Pomodoro?
        var seconds: Int
        var counter: Int = 0
        private var timer: Timer?
        
        init(seconds: Int, pomodoro: Pomodoro?) {
            self.seconds = seconds
            self.pomodoro = pomodoro
        }
        
        var isRipe: Bool {
            return counter >= seconds
        }
        
        var pomdoroRipeness: Double {
            (Double(counter) / Double(seconds)) * (pomodoro?.ripeness ?? 1.0)
        }
        
        var pomodoroSize: Double {
            PomodoroGrowth(at: pomdoroRipeness).getSize()
        }
        
        var pomodoroColor: Color {
            PomodoroGradient(at: pomdoroRipeness).getColor()
        }
        
        var formatedCounter: String {
            let time = seconds - counter
            return String(format: "%02d:%02d", time / 60, time % 60)
        }
        
        func startTimer() {
            guard timer == nil else { return }
            guard counter == 0 else { return }
            
            // Start a timer that increments the counter every second
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.counter += 1
                
                if self.counter >= self.seconds {
                                    self.stopTimer()
                                }
            }
        }
        
        func stopTimer() {
            // Invalidate the timer
            timer?.invalidate()
            timer = nil
        }
    }
}
