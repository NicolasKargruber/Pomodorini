//
//  ViewModel.swift
//  Pomodori
//
//  Created by Nicolas Kargruber on 25.11.24.
//

import SwiftUICore

extension PlantFarmView {
    @Observable
    class ViewModel2 {
        var seconds: Int
        var counter: Int = 0
        private var timer: Timer?
        
        init(seconds: Int) {
            self.seconds = seconds
        }
        
        
        var isCompleted: Bool {
            return counter >= seconds
        }
        
        var pomodorColor: Color {
            PomodoroGradient(at: Double(counter) / Double(seconds)).getColor()
        }
        
        var pomodoroSize: Double {
            PomodoroGrowth(at: Double(counter) / Double(seconds)).getSize()
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
