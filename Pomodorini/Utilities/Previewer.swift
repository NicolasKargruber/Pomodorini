//
//  Previewer.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 01.03.25.
//

import SwiftData


@MainActor
struct Previewer {
    let container: ModelContainer

    init(pomodorinoTask: PomodorinoTask? = nil) throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Pomodorino.self, PomodorinoTask.self, configurations: config)

        if(pomodorinoTask != nil) { container.mainContext.insert(pomodorinoTask!) }
        container.mainContext.insert(PomodorinoTask.newTask(named: "Lernen 📚"))
        container.mainContext.insert(PomodorinoTask.newTask(named: "Haushalt 🧹"))
    }
}
