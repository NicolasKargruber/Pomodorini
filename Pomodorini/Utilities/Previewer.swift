//
//  Previewer.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 01.03.25.
//

import SwiftData
import Foundation


@MainActor
struct Previewer {
    let container: ModelContainer

    init(pomodorinoTask: PomodorinoTask? = nil) throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Pomodorino.self, PomodorinoTask.self, configurations: config)

        // PomodorinoTasks
        if(pomodorinoTask != nil) { container.mainContext.insert(pomodorinoTask!) }
        container.mainContext.insert(PomodorinoTask.newTask(named: "Lernen 📚"))
        container.mainContext.insert(PomodorinoTask.newTask(named: "Haushalt 🧹"))
        
        // Pomodorini
        //if(pomodorinoTask != nil) { container.mainContext.insert(pomodorinoTask!) }
        container.mainContext.insert(try Pomodorino(task: pomodorinoTask, startTime: Date.now, endTime: Date.now.addingTimeInterval(1350), setDuration: 25))
        container.mainContext.insert(try Pomodorino(task: pomodorinoTask, startTime: Date.now.addingTimeInterval(1400), endTime: Date.now.addingTimeInterval(3600), setDuration: 25))
    }
}
