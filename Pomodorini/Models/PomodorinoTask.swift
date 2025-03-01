//
//  PomodorinoTask.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 26.02.25.
//


import Foundation
import SwiftData

@Model
class PomodorinoTask : Identifiable, Hashable {
    @Attribute(.unique) var id = UUID()
    var label: String
    var details: String
    var isDone: Bool = false
    
    init(label: String, details: String) {
        self.label = label
        self.details = details
    }
    
    static func newTask(named label: String) -> PomodorinoTask
    { return PomodorinoTask(label: label, details: "") }
}
