//
//  ViewModel.swift
//  Pomodori
//
//  Created by Nicolas Kargruber on 25.11.24.
//

import SwiftUICore

extension PomodoroTimerView {
    @Observable
    class ViewModel {
        var seconds: Int
        var counter: Int = 0
        private var timer: Timer?
        
        init(seconds: Int) {
            self.seconds = seconds
        }
        
        
        var isRipe: Bool {
            return counter >= seconds
        }
        
        var pomdoroRipeness: Double {
            Double(counter) / Double(seconds)
        }
        
        var pomodoroColor: Color {
            PomodoroGradient(at: pomdoroRipeness).getColor()
        }
        
        var formatedCounter: String {
            String(format: "%02d:%02d", counter / 60, counter % 60)
        }
        
        func startTimer() {
            guard timer == nil else { return }
            guard counter == 0 else { return }
            
            // Start a timer that increments the counter every second
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.counter += 1
                
                /*if self.counter >= self.seconds {
                                    self.stopTimer()
                                }*/
            }
        }
        
        func stopTimer() {
            // Invalidate the timer
            timer?.invalidate()
            timer = nil
        }
    }
}
