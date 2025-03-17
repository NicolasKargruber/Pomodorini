//
//  TransitionSheetView.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 27.02.25.
//

import SwiftUI
import SwiftData


struct TransitionSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    let timerState: PomodorinoTimerState
    
    @Query var tasks: [PomodorinoTask]
    
    var activeTasks: [PomodorinoTask] {
        let tasks = self.tasks
        
        return tasks.filter { !$0.isDone }
    }
    
    var isNewTask: Bool {
        guard let selected = selectedTask else { return true }
        return addedTasks.contains(selected)
    }
    
    // Model Content
    @Binding private var selectedTask: PomodorinoTask?
    @State private var addedTasks: [PomodorinoTask] = []
    
    // Animation
    @State private var description: String
    @State private var useOldDescription: Bool = true
    @State private var isChecked: Bool = false
    
    // Alert Dialog
    @State private var showingAlert = false
    @State private var taskLabel: String = ""
    
    // TextEditor
    //@FocusState private var isFocused: Bool
    
    init(selectedTask: Binding<PomodorinoTask?>?, timerState: PomodorinoTimerState) {
        self._selectedTask = selectedTask ?? .constant(nil)
        self.description = selectedTask?.wrappedValue?.details ?? ""
        self.timerState = timerState
    }

    var body: some View {
        VStack(alignment: .trailing) {
            doneButton
            
            // Content
            ZStack {
                    if(!activeTasks.isEmpty) {
                    editTaskContent
                } else {
                    addNewTaskContent
                }
            
                // Resize to MAX
                Color.clear.ignoresSafeArea()
            }
        }
        .padding()
        .alert("Enter Task title", isPresented: $showingAlert) {
            TextField("Enter your title", text: $taskLabel)
            Button("OK", action: { addPomodorinoTask() })
            Button("Cancel", role: .cancel, action: {})
                } message: { Text("This title must be unique to your task.") }
        .onDisappear(){
            // Save Task
            updateTaskDescription()
            updateTaskIsDone()
        }
    }
}

extension TransitionSheetView {
    
    private var editTaskContent: some View {
        VStack (spacing: 24){
            HStack {
                menu
                if(selectedTask != nil) { clearButton }
                Spacer()
            }
            textEditor
            // Bottom Views
            if (timerState == .ended) {
                 checkTaskToggleButtons
            } else if(isNewTask) {
                newTaskText
            } else {
                CustomToggleButton(isOn: $useOldDescription) {
                    if(useOldDescription) {
                        description = selectedTask?.details ?? ""
                    } else { description = "" }
                }
            }
        }
    }
    
    private var doneButton: some View {
        Button("Done",role: .cancel ,action: { dismiss() }).tint(.blue).ignoresSafeArea()
    }
    
    private var menu: some View {
        Menu (selectedTask?.label ?? "Select Task"){
            // Active Tasks
            ForEach(activeTasks){ task in
                Button(task.label, action: { selectPomodorinoTask(task) })
            }
            // + Add Task
            Button("Add Task", systemImage: "plus", action: {showingAlert.toggle()})
        }
        .disabled(timerState == .ended)
        .font(.title2).fontWeight(.semibold)
        .tint(.primary).buttonStyle(.bordered)
    }
    
    private var clearButton: some View {
        Button("Clear", systemImage: "xmark.circle.fill", action: {selectPomodorinoTask(nil)}).tint(.gray).font(.title2).labelStyle(.iconOnly)
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
                .disabled(selectedTask == nil)
        }
    }
    
    private var checkTaskToggleButtons: some View {
        Toggle("Mark as done", isOn: $isChecked)
            .toggleStyle(.switch)
    }
    
    private var newTaskText: some View {
        Text("Break down your task in the field above 🔨")
    }
    
    private var addNewTaskContent: some View {
        VStack(spacing: 0) {
            Button("Add Task", systemImage: "plus", action: {
                showingAlert.toggle()
            })
            .font(.largeTitle).labelStyle(.iconOnly)
            .buttonBorderShape(.roundedRectangle).buttonStyle(.bordered).tint(.primary)
            
            Text("Add NEW Task").font(.title).padding()
            Text("Looks like there are no tasks here! 🫥").padding()
        }
    }
    
    func addPomodorinoTask() {
        let newTask = PomodorinoTask.newTask(named: taskLabel)
        modelContext.insert(newTask)
        addedTasks.append(newTask)
        selectPomodorinoTask(newTask)
        print("Added Task: " + newTask.label)
    }
    
    func selectPomodorinoTask(_ task:PomodorinoTask?) {
        guard task != selectedTask else { return }
        
        selectedTask = task
        description = selectedTask?.details ?? ""
        useOldDescription = true
        print("TransitionSheetView | Selected Task: \(String(describing: task?.label))")
    }
    
    // TODO: Move to ViewModel
    func updateTaskDescription() {
        selectedTask?.details = description
        print("TransitionSheetView | Updated Task Label: " + (selectedTask?.label ?? ""))
    }
    
    // TODO: Move to ViewModel
    func updateTaskIsDone() {
        selectedTask?.isDone = isChecked
        print("TransitionSheetView | Updated Task is Done: \(String(describing: selectedTask?.isDone))")
    }
}

#Preview("Task - Selected", body: {
    @Previewable @State var pomodorinoTask: PomodorinoTask? =
    PomodorinoTask(label: "Pomodorino 🍅", details: "Such a cool app")
    
    Spacer()
        // Sheet
        .sheet(isPresented: .constant(true))
        { TransitionSheetView(selectedTask: $pomodorinoTask, timerState: .notStarted) }
        // ModelContainer
        .attachPreviewContainerWith(pomodorini: [], pomodorinoTasks: [pomodorinoTask!])
})

#Preview("Task - Unselected", body: {
    Spacer()
        // Sheet
        .sheet(isPresented: .constant(true))
        { TransitionSheetView(selectedTask: .constant(nil), timerState: .notStarted) }
        // ModelContainer
        .attachPreviewContainer()
})

#Preview("Task - End Focus", body: {
    @Previewable @State var pomodorinoTask: PomodorinoTask? =
    PomodorinoTask(label: "Pomodorino 🍅", details: "Such a cool app")
    
    Spacer()
        // Sheet
        .sheet(isPresented: .constant(true))
        { TransitionSheetView(selectedTask: $pomodorinoTask, timerState: .ended) }
        // ModelContainer
        .attachPreviewContainerWith(pomodorinoTasks: [pomodorinoTask])
})

#Preview("No Task", body: {
    @Previewable @State var pomodorinoTask: PomodorinoTask? = nil
    
    Spacer().sheet(isPresented: .constant(true))
    { TransitionSheetView(selectedTask: $pomodorinoTask, timerState: .notStarted) }
})
