import Combine
import SwiftUI

class ToDoViewModel: ObservableObject {
    @Published var toDoList: [ToDoItem] = []
    @Published var resetTime = Date()

    private var cancellables: Set<AnyCancellable> = []

    init() {
        // Load the saved ToDo list
        loadData()

        // Subscribe to the app life cycle events
        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { [weak self] _ in
                self?.saveData()
            }
            .store(in: &cancellables)

        // Reset unchecked ToDo items each morning
        Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkResetTime()
            }
            .store(in: &cancellables)
    }

    func addToDo() {
        let newItem = ToDoItem(emoji: "😆", title: "New ToDo", isChecked: false)
        toDoList.append(newItem)
        saveData()
    }

    func toggleToDoStatus(todo: ToDoItem) {
        if let index = toDoList.firstIndex(where: { $0.id == todo.id }) {
            toDoList[index].isChecked.toggle()
            saveData()
        }
    }

    func deleteToDo(offsets: IndexSet) {
        toDoList.remove(atOffsets: offsets)
        saveData()
    }

    func moveToDo(from source: IndexSet, to destination: Int) {
        toDoList.move(fromOffsets: source, toOffset: destination)
        saveData()
    }

    func processSwipeAction(todo: ToDoItem, direction: SwipeCardView.SwipeDirection) {
        if direction == .right {
            toggleToDoStatus(todo: todo)
        }
        saveData()
    }

    var firstUncheckedToDo: ToDoItem? {
        return toDoList.first(where: { !$0.isChecked })
    }

    func saveData() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(toDoList) {
            UserDefaults.standard.set(data, forKey: "ToDoList")
        }
    }

    private func loadData() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "ToDoList"), let decodedList = try? decoder.decode([ToDoItem].self, from: data) {
            toDoList = decodedList
        }
    }

    private func checkResetTime() {
        let calendar = Calendar.current
        let now = Date()

        if calendar.isDate(now, equalTo: resetTime, toGranularity: .minute) {
            resetToDos()
        }
    }

    private func resetToDos() {
        for index in toDoList.indices {
            toDoList[index].isChecked = false
        }
        saveData()
    }

    func addToDoWithTitle(title: String, emoji: String) {
        let newItem = ToDoItem(emoji: emoji, title: title, isChecked: false)
        toDoList.append(newItem)
        saveData()
    }

    var nextUncheckedToDo: ToDoItem? {
        guard let currentIndex = toDoList.firstIndex(where: { !$0.isChecked }) else { return nil }
        return toDoList.indices.contains(currentIndex + 1) ? toDoList[currentIndex + 1] : nil
    }
}

struct ToDoItem: Identifiable, Codable {
    var id = UUID()
    var emoji: String = "😆"
    var title: String
    var isChecked: Bool
}
