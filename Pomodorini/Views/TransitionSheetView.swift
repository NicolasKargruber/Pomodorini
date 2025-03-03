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
    
    @Query var tasks: [PomodorinoTask]
    
    @Binding private var selectedTask: PomodorinoTask?
    @State private var description: String
    
    // Alert Dialog
    @State private var showingAlert = false
    @State private var taskLabel: String = ""
    
    // TextEditor
    @FocusState private var isFocused: Bool
    
    init(selectedTask: Binding<PomodorinoTask?>?) {
        self._selectedTask = selectedTask ?? .constant(nil)
        self.description = selectedTask?.wrappedValue?.details ?? ""
    }

    var body: some View {
        VStack(alignment: .trailing) {
            doneButton
            ZStack {
                Group {
                    if(!tasks.isEmpty) {
                        VStack (spacing: 24){
                            HStack {
                                menu
                                Spacer()
                            }
                            textEditor
                            // TODO: make toggleable, on click again do action
                            pickUpToggleButtons
                        }}
                    
                    else {
                        addNewTaskButton
                    }
                }
                
                // Resize to MAX
                Color.clear.ignoresSafeArea()
            }
        }.padding().onDisappear(){
            updatePomodorinoTask()
        }
    }
}

extension TransitionSheetView {
    
    private var doneButton: some View {
        Button("Done",role: .cancel ,action: { dismiss() }).tint(.blue).ignoresSafeArea()
    }
    
    private var menu: some View {
        Menu (selectedTask?.label ?? "Select Task"){
            // Tasks
            ForEach(tasks){ task in
                Button(task.label, action: { selectPomodorinoTask(task) })
            }
            // Add Task
            Button("Add Task", systemImage: "plus", action: {showingAlert.toggle()})
        }
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
                .focused($isFocused)
                .onChange(of: isFocused, initial: true) { _, isFocused in
                    updatePomodorinoTask()
                  }
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
            }).font(.largeTitle).labelStyle(.iconOnly)
                .buttonBorderShape(.roundedRectangle).buttonStyle(.bordered).tint(.primary)
                .alert("Enter Task title", isPresented: $showingAlert) {
                    TextField("Enter your title", text: $taskLabel)
                    Button("OK", action: { addPomodorinoTask() })
                    Button("Cancel", role: .cancel, action: {})
                        } message: { Text("This title must be unique to your task.") }
        }
    }
    
    func addPomodorinoTask() {
        let newTask = PomodorinoTask.newTask(named: taskLabel)
        modelContext.insert(newTask)
        selectPomodorinoTask(newTask)
        print("Added Task: " + newTask.label)
    }
    
    func selectPomodorinoTask(_ task:PomodorinoTask) {
        selectedTask = task
        description = selectedTask?.details ?? ""
        print("Selected Task: " + task.label)
    }
    
    func updatePomodorinoTask() {
        selectedTask?.details = description
        print("Updated Task: " + (selectedTask?.label ?? ""))
    }
}

#Preview("Task - Selected", body: {
    @Previewable @State var showingSheet = true
    @Previewable @State var pomodorinoTask: PomodorinoTask? =
    PomodorinoTask(label: "Pomodorino 🍅", details: "Such a cool app")
    
    do {
        let previewer = try Previewer(pomodorinoTask: pomodorinoTask)
        return Spacer().sheet(isPresented: $showingSheet) { TransitionSheetView(selectedTask: $pomodorinoTask) }
                .modelContainer(previewer.container)
        } catch {
            return Text("Failed to create preview: \(error.localizedDescription)")
        }
})

#Preview("Task - Unselected", body: {
    @Previewable @State var showingSheet = true
    
    do {
        let previewer = try Previewer()
        return Spacer().sheet(isPresented: $showingSheet) { TransitionSheetView(selectedTask: .constant(nil)) }
                .modelContainer(previewer.container)
        } catch {
            return Text("Failed to create preview: \(error.localizedDescription)")
        }
})

#Preview("No Task", body: {
    @Previewable @State var showingSheet = true
    @Previewable @State var pomodorinoTask: PomodorinoTask? = nil
    
    Spacer().sheet(isPresented: $showingSheet) { TransitionSheetView(selectedTask: $pomodorinoTask) }
})

