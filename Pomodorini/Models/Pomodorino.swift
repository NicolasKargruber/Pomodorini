//
//  Pomodorino.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 25.11.24.
//

import SwiftUICore

struct Pomodorino: Identifiable, Hashable {
    let id = UUID()
    var task: PomodorinoTask? // In seconds
    let startTime: Date
    let endTime: Date
    let intervalDuration: Int // in minutes: Int // In seconds
    
    enum PomodorinoError: Error {
        case invalidEndTime
    }

    init(task: PomodorinoTask? = nil, startTime: Date, endTime: Date, setDuration: Int) throws {
        guard endTime > startTime else {
            throw PomodorinoError.invalidEndTime
        }
        self.task = task
        self.startTime = startTime
        self.endTime = endTime
        self.intervalDuration = setDuration
    }
    
    /// How far the timer actually progressed ( Smaller than 0  = finished early, greater than 0 = overtime)
    var progress: Double {
        let elapsedTime = endTime.timeIntervalSince(startTime) / 60 // Convert to minutes
        return elapsedTime / Double(intervalDuration)
    }

    /// Color based on ripeness (e.g., green → red → brown)
    var color: Color {
        do {
            return try PomodorinoGradient.color(forRipeness: progress)
        } catch {
            print("Pomodorino | Failed to determine Pomodorino color: \(error)")
            print("Pomodorino | Defaulting to black.")
            return .black
        }
    }
}
