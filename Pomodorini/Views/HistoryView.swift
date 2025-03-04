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
            
            if(pomodoriniOfThisMonth.isEmpty){
                Spacer()
                Text("No Pomodorini yet! 😴 ")
                Spacer()
            }
            else {scrollPomodorini}
        }
    }
}

extension HistoryView {
    private var scrollPomodorini: some View {
        ScrollView {
            LazyVStack {
                ForEach(pomodoriniOfThisMonth, id: \.self) { pomodorino in
                    PomodorinoItem(pomodorino: pomodorino)
                }
            }
        }
    }
    
    static var navigationButton: some View {
        NavigationLink(destination: HistoryView().navigationTitle(Text("History")))
        {
            // Button Content
            Label("History", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                .font(.title2).foregroundColor(.white)
                .padding(8).background(.white.opacity(0.2)).clipShape(.buttonBorder)
        }
    }
}

#Preview("HistoryView", body: {
    let pomodorinoTask = PomodorinoTask.newTask(named: "Geoguessr 🌍")
    
    do {
        let previewer = try Previewer(pomodorinoTask: pomodorinoTask)
        return HistoryView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
})


#Preview("NavigationButton", body:  {
    ZStack {
        Color.black.ignoresSafeArea()
        HistoryView.navigationButton
    }
})


