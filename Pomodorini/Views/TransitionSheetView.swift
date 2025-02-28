//
//  TransitionSheetView.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 27.02.25.
//

import SwiftUI


struct TransitionSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    //@State /*private*/ var tasks: List<PomodorinoTask> = [.empty, .empty]
    
    @Binding /*private*/ var task: PomodorinoTask?
    @State private var description: String
    
    // Alert Dialog
    @State private var showingAlert = false
    @State private var taskLabel: String = ""
    
    init(task: Binding<PomodorinoTask?>?) {
        self._task = task ?? .constant(nil)
        description = task?.wrappedValue?.description ?? ""
    }

    var body: some View {
        if((task?.hashValue) != nil) {
            VStack (spacing: 24){
                HStack {
                    menu
                    Spacer()
                }
            textEditor
            // TODO: make toggleable, on click again do action
            pickUpToggleButtons
        }.padding()}
        
        else {
            addNewTaskButton
        }
    }
}

extension TransitionSheetView {
    
    private var menu: some View {
        Menu (task?.label ?? ""){
            // TODO: for each task
            Button(action: {}){ }
            Button("Add Task", systemImage: "plus", /*role: .destructive,*/ action: {})
        }
        .font(.title2).fontWeight(.semibold)
        .tint(.primary).buttonStyle(.bordered)
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
                .disableAutocorrection(true)
                .foregroundStyle(.primary)
                .padding(.horizontal)
                .scrollContentBackground(.hidden)
                .background(.ultraThickMaterial).cornerRadius(24)
        }
    }
    
    private var pickUpToggleButtons: some View {
        VStack (spacing: 4) {
            Text("Pick up where you left off?")
                .font(.title2)
                .padding(.horizontal, 18).padding(.vertical, 12)
            
            // ToggleButtons
            HStack(spacing: 24){
                Button("YES", action: {
                    
                }).font(.title)
                    .buttonStyle(.borderedProminent)
                
                Button("NO", action: { dismiss() })
                    .buttonStyle(.bordered).tint(.blue).font(.title)
            }
        }
    }
    
    private var addNewTaskButton: some View {
        VStack(spacing: 0) {
            Text("Add NEW Task !!!").font(.title).padding()
            Button("Add Task", systemImage: "plus", action: {
                showingAlert.toggle()
                //task = PomodorinoTask.empty
            }).font(.largeTitle).labelStyle(.iconOnly)
                .buttonBorderShape(.roundedRectangle).buttonStyle(.bordered).tint(.primary)
                .alert("Enter Task title", isPresented: $showingAlert) {
                    TextField("Enter your title", text: $taskLabel)
                    Button("OK", action: { task = PomodorinoTask.newTask(named: taskLabel) })
                    Button("Cancel", role: .cancel, action: {})
                        } message: { Text("This title must be unique to your task.") }
        }
    }
    
}

#Preview("Task", body: {
    @Previewable @State var showingSheet = true
    @Previewable @State var pomodorinoTask: PomodorinoTask? =
    PomodorinoTask(label: "Pomodoro", description: "Nothing to see here yet.")
    
    Spacer().sheet(isPresented: $showingSheet) { TransitionSheetView(task: $pomodorinoTask) }
})

#Preview("No Task", body: {
    @Previewable @State var showingSheet = true
    @Previewable @State var pomodorinoTask: PomodorinoTask? = nil
    
    Spacer().sheet(isPresented: $showingSheet) { TransitionSheetView(task: $pomodorinoTask) }
})

