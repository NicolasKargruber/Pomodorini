//
//  PomodoriniApp.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 24.11.24.
//

import SwiftUI
import SwiftData

@main
struct PomodoriniApp: App {
    var body: some Scene {
        WindowGroup {
            FocusView()
                .environment(\.colorScheme, .dark) // Enforce Dark-Mode
        }.modelContainer(for: [Pomodorino.self, PomodorinoTask.self])
    }
}
