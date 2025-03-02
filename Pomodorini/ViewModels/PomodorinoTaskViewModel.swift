
import SwiftData
import SwiftUI

@Observable
class PomodorinoTaskViewModel {
    var modelContext: ModelContext
    var tasks = [PomodorinoTask]()

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchTasks()
    }

    func addTask(label: String, details: String = "") {
        let task = PomodorinoTask(label: label, details: details)
        modelContext.insert(task)
        fetchTasks()
    }
    
    func deleteTask(label: String, details: String = "") {
        let task = PomodorinoTask(label: label, details: details)
        modelContext.insert(task)
        fetchTasks()
    }

    func fetchTasks() {
        do {
            // TODO: Filter by isDone
            let descriptor = FetchDescriptor<PomodorinoTask>(sortBy: [SortDescriptor(\.label)])
            tasks = try modelContext.fetch(descriptor)
        } catch {
            print("PomodorinoTaskViewModel | Fetching failed: ", error)
        }
    }
}
