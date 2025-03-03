//
//  Pomodorino.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 25.11.24.
//

import SwiftUICore
import SwiftData

@Model
class Pomodorino: Identifiable, Hashable {
    @Attribute(.unique) var id = UUID()
    var task: PomodorinoTask? // In seconds
    var startTime: Date
    var endTime: Date?
    var intervalDuration: Int // in minutes: Int // In seconds
    
    enum PomodorinoError: Error {
        case invalidEndTime
    }

    init(task: PomodorinoTask? = nil, startTime: Date, endTime: Date? = nil, setDuration: Int) throws {
        if let endTime, endTime <= startTime {
            throw PomodorinoError.invalidEndTime
        }
        self.task = task
        self.startTime = startTime
        self.endTime = endTime
        self.intervalDuration = setDuration
    }
    
    /// How far the timer actually progressed
    /// ( Smaller than 0  = finished early, greater than 0 = overtime)
    var hasTask: Bool {
        return task != nil
    }
    
    /// Final progress value of Pomodorino
    var ripeness: Double {
        guard let endTime else {
            print("Pomodorino | endTime is negative! Defaulting to '0'.")
            return 0
        }
        let elapsedTime = endTime.timeIntervalSince(startTime) / 60 // Convert to minutes
        return elapsedTime / Double(intervalDuration)
    }

    /// Color based on ripeness
    /// (e.g., green → red → brown, ERROR → black)
    var color: Color { PomodorinoGradient.color(forRipeness: ripeness) }
    
    // TODO: Remove -> '!'
    static func new(startTime: Date, setDuration: Int) -> Pomodorino
    { return try! Pomodorino(startTime: startTime, setDuration: setDuration) }
}
