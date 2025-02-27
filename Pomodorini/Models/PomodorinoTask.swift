//
//  PomodorinoTask.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 26.02.25.
//


import Foundation

struct PomodorinoTask : Identifiable, Hashable {
    let id = UUID()
    var label: String
    var description: String
    var isDone: Bool = false
}
