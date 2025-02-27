//
//  TransitionSheetView.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 27.02.25.
//

import SwiftUI


struct TransitionSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var description: String = ""

    var body: some View {
        VStack (spacing: 24){
            taskLabel
            textEditor
            // TODO: make toggleable, on click again do action
            pickUpToggleButtons
        }.padding()
    }
}

extension TransitionSheetView {
    private var taskLabel: some View {
        HStack {
            Text("Lernen").font(.title2).fontWeight(.semibold)
                .padding(.horizontal, 18).padding(.vertical, 12)
                .background(.regularMaterial).cornerRadius(12)
            
            Spacer()
        }
    }
    
    private var textField: some View {
        TextField(
            "Enter task description here...",
            text: $description, axis: .vertical
        )
        .lineLimit(5...10)
        .disableAutocorrection(true)
        .textFieldStyle(.roundedBorder)
    }
    
    private var textEditor: some View {
        
        VStack(alignment: .leading) {
            Text("Enter Task Description below...").padding(.horizontal, 8)
            
            TextEditor(text: $description)
                .foregroundStyle(.primary)
                .padding(.horizontal)
            .scrollContentBackground(.hidden)
            .background(.ultraThickMaterial).cornerRadius(24)
        }
    }
    
    private var pickUpToggleButtons: some View {
        VStack (spacing: 8) {
            Text("Pick up where you left off?")
                .font(.title2)
                .padding(.horizontal, 18).padding(.vertical, 12)
            
            // ToggleButtons
            HStack(spacing: 24){
                Button(action: {
                    
                })
                { Text("YES").font(.title) }
                    .buttonStyle(.borderedProminent)
                
                Button(action: { dismiss() })
                { Text("NO").font(.title).padding(.horizontal, 4) }
                    .buttonStyle(.bordered).tint(.blue)
            }
        }
    }
    
}

#Preview {
    @Previewable @State var showingSheet = true
    Spacer().sheet(isPresented: $showingSheet) { TransitionSheetView() }
}

