//
//  PomodoriniButton.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 22.12.24.
//

import SwiftUI

struct PomodoriniButton: View {
    /// The total count of collected Pomodorini.
    @AppStorage("pomodorinoCount") var pomodorinoCount = 0
    @State var showingConfirmation = false
    
    var body: some View {
        Button(action: {}){
            HStack {
                Text("\(pomodorinoCount)")
                    // Animation
                    .id(pomodorinoCount)
                    .transition(.move(edge: .top)).animation(.default, value: pomodorinoCount)
                Text("🍅")
            }
        }.clipped()
        .simultaneousGesture(
            LongPressGesture().onEnded { _ in showingConfirmation.toggle() }
        )
        .font(.title)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .buttonStyle(.bordered)
        .tint(.white)
        .confirmationDialog("Reset Pomodorino Count", isPresented: $showingConfirmation) {
            Button("Reset", role: .destructive) { pomodorinoCount = 0 }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Cannot be undone but won't affect your history.\n\nReset Count?")
        }
    }
}

#Preview {
    @Previewable @AppStorage("pomodorinoCount") var pomodorinoCount = 0
    Color.black.ignoresSafeArea().overlay{
        PomodoriniButton()
    }/*.onTapGesture {
        pomodorinoCount+=1
    }*/
}
