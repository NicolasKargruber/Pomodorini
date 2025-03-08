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
            ZStack {
                Group {
                    if(!activeTasks.isEmpty) {
                        VStack (spacing: 24){
                            HStack {
                                menu
                                if(selectedTask != nil) {
                                    Button("Clear", systemImage: "xmark.circle.fill", action: {selectPomodorinoTask(nil)}).tint(.gray).font(.title2).labelStyle(.iconOnly)
                                }
                                Spacer()
                            }
                            textEditor
                            // Bottom Views
                            if (timerState == .ended) {
                                 checkTaskToggleButtons
                            } else if(isNewTask) {
                                Text("Break down your task in the field above 🔨")
                            } else {
                                CustomToggleButton(isOn: $useOldDescription) {
                                    if(useOldDescription) {
                                        description = selectedTask?.details ?? ""
                                    } else { description = "" }
                                }
                            }
                        }}
                    else {
                        addNewTaskButton
                    }
                }
                
                // Resize to MAX
                Color.clear.ignoresSafeArea()
            }
        }
        .padding()
        .onDisappear(){
            updateTaskLabel()
            updateTaskIsDone()
        }
    }
}

extension TransitionSheetView {
    
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
        .alert("Enter Task title", isPresented: $showingAlert) {
            TextField("Enter your title", text: $taskLabel)
            Button("OK", action: {
                addPomodorinoTask()
            })
            Button("Cancel", role: .cancel, action: {})
                } message: { Text("This title must be unique to your task.") }
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
    
    private var addNewTaskButton: some View {
        VStack(spacing: 0) {
            Button("Add Task", systemImage: "plus", action: {
                showingAlert.toggle()
            }).font(.largeTitle).labelStyle(.iconOnly)
                .buttonBorderShape(.roundedRectangle).buttonStyle(.bordered).tint(.primary)
                .alert("Enter Task title", isPresented: $showingAlert) {
                    TextField("Enter your title", text: $taskLabel)
                    Button("OK", action: { addPomodorinoTask() })
                    Button("Cancel", role: .cancel, action: {})
                        } message: { Text("This title must be unique to your task.") }
            
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
        print("Selected Task: \(String(describing: task?.label))")
    }
    
    func updateTaskLabel() {
        selectedTask?.details = description
        print("Updated Task Label: " + (selectedTask?.label ?? ""))
    }
    
    func updateTaskIsDone() {
        print("Checked: \(isChecked)")
        selectedTask?.isDone = isChecked
        print("Updated Task is Done: \(String(describing: selectedTask?.isDone))")
    }
}

#Preview("Task - Selected", body: {
    @Previewable @State var showingSheet = true
    @Previewable @State var pomodorinoTask: PomodorinoTask? =
    PomodorinoTask(label: "Pomodorino 🍅", details: "Such a cool app")
    
    do {
        let previewer = try Previewer(pomodorinoTask: pomodorinoTask)
        return Spacer().sheet(isPresented: $showingSheet) { TransitionSheetView(selectedTask: $pomodorinoTask, timerState: .notStarted) }
                .modelContainer(previewer.container)
        } catch {
            return Text("Failed to create preview: \(error.localizedDescription)")
        }
})

#Preview("Task - Unselected", body: {
    @Previewable @State var showingSheet = true
    
    do {
        let previewer = try Previewer()
        return Spacer().sheet(isPresented: $showingSheet) { TransitionSheetView(selectedTask: .constant(nil), timerState: .notStarted) }
                .modelContainer(previewer.container)
        } catch {
            return Text("Failed to create preview: \(error.localizedDescription)")
        }
})

#Preview("Task - End Focus", body: {
    @Previewable @State var showingSheet = true
    @Previewable @State var pomodorinoTask: PomodorinoTask? =
    PomodorinoTask(label: "Pomodorino 🍅", details: "Such a cool app")
    
    do {
        let previewer = try Previewer(pomodorinoTask: pomodorinoTask)
        return Spacer().sheet(isPresented: $showingSheet) { TransitionSheetView(selectedTask: $pomodorinoTask, timerState: .ended) }
                .modelContainer(previewer.container)
        } catch {
            return Text("Failed to create preview: \(error.localizedDescription)")
        }
})

#Preview("Task - Selected- End Focus", body: {
    @Previewable @State var showingSheet = true
    @Previewable @State var pomodorinoTask: PomodorinoTask? =
    PomodorinoTask(label: "Pomodorino 🍅", details: "Such a cool app")
    
    do {
        let previewer = try Previewer(pomodorinoTask: pomodorinoTask)
        return Spacer().sheet(isPresented: $showingSheet) { TransitionSheetView(selectedTask: $pomodorinoTask, timerState: .ended) }
                .modelContainer(previewer.container)
        } catch {
            return Text("Failed to create preview: \(error.localizedDescription)")
        }
})

#Preview("No Task", body: {
    @Previewable @State var showingSheet = true
    @Previewable @State var pomodorinoTask: PomodorinoTask? = nil
    
    Spacer().sheet(isPresented: $showingSheet) { TransitionSheetView(selectedTask: $pomodorinoTask, timerState: .notStarted) }
})

