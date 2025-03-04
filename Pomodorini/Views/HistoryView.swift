//
//  HistoryView.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 04.03.25.
//


import SwiftUI
import SwiftData


struct HistoryView : View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query var pomodorini: [Pomodorino]
    
    var pomodoriniOfThisMonth: [Pomodorino] {
        let pomodorini = self.pomodorini
        
        return pomodorini.filter {
            Calendar.current.dateComponents([.day], from: $0.startTime).day == Calendar.current.dateComponents([.day], from: date).day
        }.sorted(by: { $0.startTime < $1.startTime })
    }
    
    @State private var date = Date.now
    
    var body: some View {
        
        VStack {
            DatePicker(
                "Date",
                selection: $date,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            
            Divider().background(Color.primary)
            
            scrollView
        }
    }
}

extension HistoryView {
    private var scrollView: some View {
        ScrollView {
            if(pomodorini.isEmpty){
                Text("No Pomodorini yet! 😴 ")
            }
            else {
                LazyVStack {
                    ForEach(pomodoriniOfThisMonth, id: \.self) { pomodorino in
                        PomodorinoItem(pomodorino: pomodorino)
                    }
                }
            }
        }
    }
}

#Preview {
    let pomodorinoTask = PomodorinoTask.newTask(named: "Geoguessr 🌍")
    
    do {
        let previewer = try Previewer(pomodorinoTask: pomodorinoTask)
        return HistoryView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

