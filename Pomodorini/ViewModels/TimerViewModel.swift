//
//  TimerViewModel.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 05.12.24.
//


import Foundation
import Combine
import SwiftUI

@Observable
class TimerViewModel {
    // MARK: - Private Properties
    
    private let intervalDuration: TimeInterval              // Total duration in seconds
    private(set) var remainingTime: TimeInterval            // Remaining time in seconds
    private var overtime: TimeInterval = TimeInterval(0)  // Overtime in seconds
    private(set) var startTime: Date?                       // Start time of the timer
    private var timer: Timer?                               // Timer object
    private var threshold: Double = 0.079                   // Completion threshold 8%

    // MARK: - Initializer
    
    init(intervalDuration: Int) {
        let clampedMinutes = max(1, min(intervalDuration, 60)) // Ensure a valid duration
        
        // #Preview
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        { self.intervalDuration = TimeInterval(intervalDuration) }
        else { self.intervalDuration = TimeInterval(clampedMinutes * 60) }
        
        self.remainingTime = self.intervalDuration
    }
    
    // MARK: - Computed Properties
    
    /// Predicted time when user will end Timer
    var predictedEndTime: Date?  {
        guard let start = startTime else {
            print("TimerViewModel | Cannot predict EndTime. StartTime not defined.")
            return nil
        }
        return start.addingTimeInterval(intervalDuration)
    }
    
    /// Actual time when Timer stopped
    var endTime: Date?  {
        guard let predicted = predictedEndTime else { return nil }
        return predicted.addingTimeInterval(-remainingTime).addingTimeInterval(+overtime)
    }
    
    /// Timer Interval for Live Activity.
    var timerInterval: ClosedRange<Date> {
        guard let start = startTime, let end = predictedEndTime else {
            print("TimerViewModel | StartTime OR EndTime have no value. Return default value.")
            let now = Date.now; return now...now
        }
        return start...end
    }
    
    /// Indicates whether the timer ran more than 1 minute
    var ranMoreThan1Minute: Bool {
        intervalDuration - remainingTime >= 60
    }
    
    /// Determines the state of the pomodorino timer.
    var timerState: PomodorinoTimerState {
        if(hasEnded){ return .ended }
        else if isEndable { return .endable }
        else if isRunning { return .running }
        else { return .notStarted }
    }
    
    /// Indicates whether the timer is in the "completable" phase.
    var isEndable: Bool {
        progress + threshold >= 1.0 || isCompleted
    }
    
    /// Indicates whether the timer has completed.
    var isCompleted: Bool {
        remainingTime <= 0
    }
    
    /// Becomes true when the timer gets invalidated.
    var hasEnded: Bool {
        startTime != nil && predictedEndTime != nil && !isRunning
    }
    
    /// Indicates whether the timer is currently running.
    var isRunning: Bool {
        timer?.isValid ?? false
    }
    
    /// Indicates whether it is time to show a friendly reminder
    var isTimeForAwareness: Bool {
        ranMoreThan1Minute && Int((remainingTime + overtime) / 60) % 5 == 4 && isRunning
    }
    
    /// The timer's progress as a value from 0.0 to 1.0.
    var progress: Double {
        let timeElapsed = intervalDuration - remainingTime + overtime
        return timeElapsed / intervalDuration
    }
    
    /// A formatted string representation of the remaining time.
    var formattedTime: String {
        formatTime(remainingTime)
    }
    
    /// A formatted string representation of the overtime.
    var formattedOvertime: String {
        "+\(formatTime(overtime))"
    }
    
    // MARK: - Public methods
    
    /// Starts the timer.
    func startTimer() {
        guard timer == nil else { return } // Prevent multiple timers
        startTime = Date.now
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTime()
        }
    }
    
    /// Stops the timer.
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// Resets the timer to its initial state.
    func resetTimer() {
        if(isRunning) { stopTimer() }
        remainingTime = intervalDuration
        overtime = TimeInterval(0)
        startTime = nil
    }
    
    // MARK: - Private Methods
    
    /// Updates the remaining time and handles timer completion.
    private func updateTime() {
        guard let predicted = predictedEndTime else { return }
        let now = Date()
        
        remainingTime = max(predicted.timeIntervalSince(now), 0)
        if remainingTime == 0 /*&& allowsOvertime*/ {
            overtime = abs(now.timeIntervalSince(predicted))
        }
        
        // Stop overtime at 59:59 hour
        if overtime >= (60 * 60) - 1 {
            stopTimer()
        }
    }
    
    /// Formats a time interval into a "MM:SS" string.
    private func formatTime(_ time: TimeInterval) -> String {
        let totalSeconds = Int(time.rounded())
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
