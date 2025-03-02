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
    
    /// How far the timer actually progressed ( Smaller than 0  = finished early, greater than 0 = overtime)
    var progress: Double {
        guard let endTime else {
            print("Pomodorino | endTime is negative! Defaulting to '0'.")
            return 0
        }
        let elapsedTime = endTime.timeIntervalSince(startTime) / 60 // Convert to minutes
        return elapsedTime / Double(intervalDuration)
    }

    /// Color based on ripeness (e.g., green → red → brown)
    var color: Color {
        do {
            return try PomodorinoGradient.color(forRipeness: progress)
        } catch {
            print("Pomodorino | Failed to determine Pomodorino color: \(error)")
            print("Pomodorino | Defaulting to '.black'.")
            return .black
        }
    }
    
    // TODO: Remove !
    static func new(startTime: Date, setDuration: Int) -> Pomodorino
    { return try! Pomodorino(startTime: startTime, setDuration: setDuration) }
}
