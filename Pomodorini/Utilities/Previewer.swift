//
//  Previewer.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 01.03.25.
//

import SwiftUI
import SwiftData
import Foundation


@MainActor
struct Previewer {
    let container: ModelContainer

    init(pomodorini: [Pomodorino] = [], pomodorinoTasks: [PomodorinoTask?] = [], inMemory: Bool = true) throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Pomodorino.self, PomodorinoTask.self, configurations: config)
        
        // PomodorinoTasks
        for(pomodorinoTask) in pomodorinoTasks {
            if(pomodorinoTask != nil) { container.mainContext.insert(pomodorinoTask!) }
        }
        container.mainContext.insert(PomodorinoTask.newTask(named: "Lernen 📚"))
        container.mainContext.insert(PomodorinoTask.newTask(named: "Haushalt 🧹"))
        let pomodorinoTask: PomodorinoTask? = pomodorinoTasks.first ?? nil
        
        // Pomodorini
        for(pomodorino) in pomodorini {
            container.mainContext.insert(pomodorino)
        }
        container.mainContext.insert(try Pomodorino(task: pomodorinoTask, startTime: Date.now.addingTimeInterval(-5000), endTime: Date.now.addingTimeInterval(-3550), setDuration: 25))
        container.mainContext.insert(try Pomodorino(task: pomodorinoTask, startTime: Date.now.addingTimeInterval(-3600), endTime: Date.now.addingTimeInterval(-1400), setDuration: 25))
    }
}

extension View {
    func attachPreviewContainer() -> AnyView {
        attachPreviewContainerWith()
    }
    
    func attachPreviewContainerWith(pomodorini: [Pomodorino] = [], pomodorinoTasks: [PomodorinoTask?] = []) -> AnyView {
        do {
            let previewer = try Previewer(pomodorini: pomodorini, pomodorinoTasks: pomodorinoTasks)
            return AnyView(self.modelContainer(previewer.container))
        } catch {
            return AnyView(Text("Failed to create preview.\n\n\(error.localizedDescription)"))
        }
    }
}

