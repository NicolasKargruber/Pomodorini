//
//  PomodorinoItem.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 04.03.25.
//

import SwiftUI

struct PomodorinoItem: View {
    let pomodorino: Pomodorino
    
    // Initialize the format style
    var referenceFormatter: SystemFormatStyle.DateReference {
        .reference(to: pomodorino.endTime ?? Date.now)
    }
    
    var duration : String {
        let durationInMinutes: Double = pomodorino.elapsedTime * 60
        return Duration.seconds(Int(durationInMinutes.rounded()))
            .formatted(.time(pattern: .hourMinute))
    }
    
    var body: some View {
        VStack {
            Text("PoModoRIno 🍅").font(.caption2)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            
            HStack {
                Text(pomodorino.task?.label ?? "")
                Spacer()
                Text(duration).font(.title2).fontWeight(.semibold)
            }
        }
        .foregroundColor(.white)
        .padding()
        .background(pomodorino.color)
        .frame(maxWidth: .infinity, maxHeight: .infinity).cornerRadius(12)
        .padding(.horizontal, 8)
    }
}



#Preview {
    let pomodorinoTask = PomodorinoTask.newTask(named: "Geoguessr 🌍")
    let pomodorino = try! Pomodorino(task: pomodorinoTask, startTime: Date.now, endTime: Date.now.addingTimeInterval(1350), setDuration: 25)
    
    LazyVStack {
        PomodorinoItem(pomodorino: pomodorino)
    }
}
