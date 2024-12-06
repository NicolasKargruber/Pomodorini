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
    let totalDuration: TimeInterval  // Total duration in seconds
    private var remainingTime: TimeInterval  // Total time left in seconds
    private var overtime: TimeInterval?      // Overtime in seconds
    private var startTime: Date?             // Actual start time
    private var endTime: Date?               // Predicted end time
    private var timer: Timer?                // Timer object
    private var isOvertimeEnabled: Bool      // Overtime toggle
    
    init(totalMinutes: Int, allowOvertime: Bool = false) throws {
        // Clamp totalMinutes between 0 and 60
        let clampedMinutes = max(0, min(totalMinutes, 60))
        self.totalDuration = TimeInterval(clampedMinutes * 60)
        
        self.remainingTime = TimeInterval(totalMinutes * 60)
        self.isOvertimeEnabled = allowOvertime
    }
    
    var formattedTime: String {
        (formatTime(remainingTime))
    }
    
    var formattedOvertime: String {
        (formatTime(overtime ?? TimeInterval(0)))
    }
    
    var progress: Double {
        1 - (Double(remainingTime) / Double(totalDuration)) + Double(overtime ?? 0.0)
    }
    
    var isCompleted: Bool {
        remainingTime <= 0
    }
    
    func start() {
        guard timer == nil else { return }  // Prevent multiple timers
        
        // START Time
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
    
    private func updateTime() {
        guard let _ = startTime, let endTime = endTime else { return }
        let now = Date()
        remainingTime = endTime.timeIntervalSince(now)
        
        if remainingTime <= 0 {
            if isOvertimeEnabled {
                overtime = now.timeIntervalSince(endTime)
            } else {
                stop()
                overtime = nil
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
