//
//  TimerManager.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 05.12.24.
//


import Foundation
import Combine

@Observable
class TimerViewModel {
    // MARK: - Properties
    
    private let totalDuration: TimeInterval  // Total duration in seconds
    private var _remainingTime: TimeInterval // Remaining time in seconds
    var remainingTime: TimeInterval { _remainingTime }
    private var overtime: TimeInterval?      // Overtime in seconds
    private var startTime: Date?             // Start time of the timer
    private var endTime: Date?               // End time of the timer
    private var timer: Timer?                // Timer object
    private var threshold: Double = 0.079    // Completion threshold (percentage: 0.0 - 1.0)

    // MARK: - Initializer
    
    /// Initializes a new TimerManager with the specified configuration.
    /// - Parameters:
    ///   - totalMinutes: The total timer duration in minutes.
    ///   - threshold: The completion threshold (default 8%).
    init(totalMinutes: Int, threshold: Double? = nil) {
        let clampedMinutes = max(1, min(totalMinutes, 60)) // Ensure a valid duration
        
        // #Preview
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        { self.totalDuration = TimeInterval(30) }
        else { self.totalDuration = TimeInterval(clampedMinutes * 60) }
        
        self._remainingTime = self.totalDuration
        
        if let threshold, (0...1).contains(threshold) {
            self.threshold = threshold
        } else {
            print("Invalid OR no threshold value provided. Set to default value.")
            self.threshold = 0.08 // Explicitly set the default
        }
    }
    
    // MARK: - Computed Properties
    
    /// Indicates whether the timer is in the "completable" phase.
    var isCompletable: Bool {
        progress + threshold >= 1.0 || isCompleted
    }
    
    /// Indicates whether the timer has completed.
    var isCompleted: Bool {
        _remainingTime <= 0
    }
    
    /// Indicates whether the timer is currently running.
    var isRunning: Bool {
        timer?.isValid ?? false
    }
    
    /// The timer's progress as a value from 0.0 to 1.0.
    var progress: Double {
        let timeElapsed = totalDuration - _remainingTime + (overtime ?? 0)
        return timeElapsed / totalDuration
    }
    
    /// A formatted string representation of the remaining time.
    var formattedTime: String {
        formatTime(_remainingTime)
    }
    
    /// A formatted string representation of the overtime.
    var formattedOvertime: String {
        "+\(formatTime(overtime ?? 0))"
    }
    
    // MARK: - Timer Controls
    
    /// Starts the timer.
    func start() {
        guard timer == nil else { return } // Prevent multiple timers
        startTime = Date()
        endTime = startTime?.addingTimeInterval(totalDuration)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTime()
        }
    }
    
    /// Stops the timer.
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    /// Resets the timer to its initial state.
    func reset() {
        _remainingTime = totalDuration
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
            stop()
        }
    }
    
    /// Formats a time interval into a "MM:SS" string.
    /// - Parameter time: The time interval to format.
    /// - Returns: A formatted string.
    private func formatTime(_ time: TimeInterval) -> String {
        let totalSeconds = Int(time.rounded())
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
