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
    
    private let intervalDuration: TimeInterval  // Total duration in seconds
    private var _remainingTime: TimeInterval // Remaining time in seconds
    var remainingTime: TimeInterval { _remainingTime }
    private var overtime: TimeInterval?      // Overtime in seconds
    private var startTime: Date?             // Start time of the timer
    var endTime: Date?               // End time of the timer
    private var timer: Timer?                // Timer object
    private var threshold: Double = 0.079    // Completion threshold (percentage: 0.0 - 1.0)

    // MARK: - Initializer
    
    /// Initializes a new TimerManager with the specified configuration.
    /// - Parameters:
    ///   - totalMinutes: The total timer duration in minutes.
    ///   - threshold: The completion threshold (default 8%).
    init(intervalDuration: Int, threshold: Double? = nil) {
        let clampedMinutes = max(1, min(intervalDuration, 60)) // Ensure a valid duration
        
        // #Preview
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        { self.intervalDuration = TimeInterval(30) }
        else { self.intervalDuration = TimeInterval(clampedMinutes * 60) }
        
        self._remainingTime = self.intervalDuration
        
        if let threshold, (0...1).contains(threshold) {
            self.threshold = threshold
        } else {
            print("TimerViewModel | Invalid OR no threshold value provided. Set to default value.")
            self.threshold = 0.08 // Explicitly set the default
        }
    }
    
    // MARK: - Computed Properties
    
    /// Timer Interval for Live Activity.
    var timerInterval: ClosedRange<Date> {
        guard let start = startTime, let end = endTime else {
            print("TimerViewModel | StartTime OR EndTime have no value. Return default value.")
            let now = Date.now; return now...now
        }
        return start...end
    }
    
    /// Determines the state of the pomodorino timer.
    var timerState: PomodorinoTimerState {
        if(hasEnded){
            return .ended
        }
        else if isEndable {
            return .endable
        } else if isRunning {
            return .running
        } else {
            return .notStarted
        }
    }
    
    /// Indicates whether the timer is in the "completable" phase.
    var isEndable: Bool {
        progress + threshold >= 1.0 || isCompleted
    }
    
    /// Indicates whether the timer has completed.
    var isCompleted: Bool {
        _remainingTime <= 0
    }
    
    /// Becomes true when the timer gets invalidated.
    var hasEnded: Bool {
        startTime != nil && endTime != nil && !isRunning
    }
    
    /// Indicates whether the timer is currently running.
    var isRunning: Bool {
        timer?.isValid ?? false
    }
    
    /// The timer's progress as a value from 0.0 to 1.0.
    var progress: Double {
        let timeElapsed = intervalDuration - _remainingTime + (overtime ?? 0)
        return timeElapsed / intervalDuration
    }
    
    /// A formatted string representation of the remaining time.
    var formattedTime: String {
        formatTime(_remainingTime)
    }
    
    /// A formatted string representation of the overtime.
    var formattedOvertime: String {
        "+\(formatTime(overtime ?? 0))"
    }
    
    // MARK: - Public methods
    
    /// Starts the timer.
    func startTimer() {
        guard timer == nil else { return } // Prevent multiple timers
        startTime = Date()
        endTime = startTime?.addingTimeInterval(intervalDuration)
        
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
        _remainingTime = intervalDuration
        overtime = nil
        startTime = nil
        endTime = nil
    }
    
    // MARK: - Private Methods
    
    /// Updates the remaining time and handles timer completion.
    private func updateTime() {
        guard let endTime = endTime else { return }
        let now = Date()
        
        _remainingTime = max(endTime.timeIntervalSince(now), 0)
        if _remainingTime == 0 /*&& allowsOvertime*/ {
            overtime = abs(now.timeIntervalSince(endTime))
        } else if _remainingTime == 0 {
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
