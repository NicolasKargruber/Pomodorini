//
//  ColorError.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 04.12.24.
//

enum PomodorinoRipenessError: Error {
    case outOfRange(value: Double)
    case noMatchingElement(value: Double)
    
    var localizedDescription: String {
        switch self {
        case .outOfRange(let value):
            return "Invalid ripeness value: \(value). It must be between 0.0 and 2.0."
        case .noMatchingElement(let value):
            return "No matching image for progress value: \(value)"
        }
    }
}
