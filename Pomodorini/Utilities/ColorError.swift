//
//  ColorError.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 04.12.24.
//

enum ColorError: Error {
    case percentageOutOfRange(value: Double)
    
    var localizedDescription: String {
        switch self {
        case .percentageOutOfRange(let value):
            return "Invalid percentage value: \(value). It must be between 0.0 and 2.0."
        }
    }
}
