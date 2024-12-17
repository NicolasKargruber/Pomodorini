//
//  TimerManager.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 05.12.24.
//


import Foundation
import Combine

@Observable
class TimerManager {
    // TODO: Rename to -ViewModel or -Controller
    
    private let totalDuration: TimeInterval  // Total duration in seconds
    private var remainingTime: TimeInterval  // Total time left in seconds
    private var overtime: TimeInterval?      // Overtime in seconds
    private var startTime: Date?             // Actual start time
    private var endTime: Date?               // Predicted end time
    private var timer: Timer?                // Timer object
    private var allowsOvertime: Bool      // Overtime toggle
    
    init(totalMinutes: Int, allowsOvertime: Bool = false) throws {
        // Clamp total minutes between 0 and 60
        let clampedMinutes = max(0, min(totalMinutes, 60))
        let totalSeconds = clampedMinutes * 60
        self.totalDuration = TimeInterval(totalSeconds)
        
        self.remainingTime = TimeInterval(totalSeconds)
        self.allowsOvertime = allowsOvertime
        
        // TODO: warning when total & remaining !=
    }
    
    var formattedTime: String {
        (formattedTimeString(for: remainingTime))
    }
    
    var formattedOvertime: String {
        "+\(formattedTimeString(for: overtime ?? TimeInterval(0)))"
    }
    
    var progress: Double {
        // 1 - (ACTUAL / EXPECTED)
        let timePassed = Double(totalDuration) - Double(remainingTime) + Double(overtime ?? 0.0)
        let progress = timePassed / Double(totalDuration)
        print("Timer progressed:", progress); return progress
    }
    
    var isCompleted: Bool {
        remainingTime <= 0
    }
    
    var isRunning: Bool {
        timer?.isValid ?? false
    }
    
    func start() {
        guard timer == nil else { return }  // Prevent multiple timers
        
        // START Time
        startTime = Date()
        guard let startTime = startTime else {
                print("Start time is not initialized.")
                return
            }
        
        // END Time
        endTime = startTime.addingTimeInterval(totalDuration)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTime()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func reset() {
        remainingTime = totalDuration
        overtime = nil
        startTime = nil
        endTime = nil
        
        print("TimerManager reseted")
    }
    
    private func updateTime() {
        guard let _ = startTime, let endTime = endTime else { return }
        
        // Running
        let now = Date()
        remainingTime = endTime.timeIntervalSince(now) + 0.5
        if(remainingTime < 0) {remainingTime = 0}
        print("Time left: \(remainingTime)")
        
        // Finished
        if remainingTime <= 0 {
            // Notification
            NotificationManager.shared.scheduleNotification(
                title: "Pomodorino Complete!",
                body: "Your Pomodorino timer is done. Take a break! 🍅",
                timeInterval: 1 // Trigger immediately (for testing)
            )
            
            if allowsOvertime {
                // Overtime
                overtime = now.timeIntervalSince(endTime)
            } else {
                stop()
                overtime = nil
            }
        }
    }
    
    private func formattedTimeString(for time: TimeInterval) -> String {
        let totalSeconds = Int(round(time))
        print("Rounded to \(totalSeconds)")
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
