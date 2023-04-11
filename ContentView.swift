import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ToDoViewModel()

    var body: some View {
        TabView {
            MainView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("ToDo")
                }

            ToDoListView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "list.dash.header.rectangle")
                    Text("routine")
                }

            SettingsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

struct MainView: View {
    @ObservedObject var viewModel: ToDoViewModel
    let emojis: [String] = ["😀", "🙌", "😁", "😆", "🐟", "🤣", "😊", "😇", "🍙", "🍣", "🧹", "🚽", "💤", "☎️"]
    var body: some View {
        ZStack {
            if let todo = viewModel.firstUncheckedToDo {
                SwipeCardView(toDoItem: todo, onRemove: { direction in
                    viewModel.processSwipeAction(todo: todo, direction: direction)
                })
                Spacer()
            } else {
                VStack {
                    Spacer()
                    Text("You Finished All ToDos")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                        .bold()
                        .padding()
                    Text(randomEmoji(emojis: emojis)).font(.largeTitle)
                    Spacer()
                }
            }
        }
    }

    func randomEmoji(emojis: [String]) -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(emojis.count)))
        return emojis[randomIndex]
    }
}

struct ToDoListView: View {
    @ObservedObject var viewModel: ToDoViewModel
    @State private var newToDoTitle: String = ""
    @State private var newToDoEmoji: String = ""
    @State private var isEditMode: Bool = false

    let todoEmojis: [String] = ["😆", "🍔", "🍣", "🧹", "🚽", "💤", "☎️", "💊", "🏥", "💉"]

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    isEditMode.toggle()
                }) {
                    Text(isEditMode ? "Done" : "Edit")
                        .bold()
                        .foregroundColor(.blue)
                }
                .padding(.trailing)
            }
            if viewModel.toDoList.isEmpty {
                Spacer()
                Text("You Can Add Your ToDo")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .padding()
                Spacer()
            } else {
                List {
                    ForEach(viewModel.toDoList.indices, id: \.self) { index in
                        HStack {
                            if isEditMode {
                                TextField("Edit ToDo Title", text: Binding(
                                    get: { viewModel.toDoList[index].title },
                                    set: { viewModel.toDoList[index].title = $0; viewModel.saveData() }
                                ))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            } else {
                                Button(action: {
                                    viewModel.toggleToDoStatus(todo: viewModel.toDoList[index])
                                }) {
                                    HStack {
                                        Text(viewModel.toDoList[index].emoji + viewModel.toDoList[index].title)
                                            .strikethrough(viewModel.toDoList[index].isChecked, color: .red)
                                            .foregroundColor(viewModel.toDoList[index].isChecked ? .gray : .black)
                                        Spacer()
                                        if viewModel.toDoList[index].isChecked {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteToDo)
                    .onMove(perform: viewModel.moveToDo)
                }
                .environment(\.editMode, isEditMode ? .constant(.active) : .constant(.inactive))
            }
            HStack {
                Picker("", selection: $newToDoEmoji) {
                    ForEach(todoEmojis, id: \.self) { emoji in
                        Text(emoji)
                            .font(.largeTitle)
                    }
                }
                TextField("Enter New ToDo", text: $newToDoTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    if newToDoTitle != "" {
                        viewModel.addToDoWithTitle(title: newToDoTitle, emoji: newToDoEmoji != "" ? newToDoEmoji : "😢")
                        newToDoTitle = ""
                    }
                }) {
                    Text("+")
                        .bold()
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

struct SettingsView: View {
    @ObservedObject var viewModel: ToDoViewModel

    var body: some View {
        VStack {
            Group {
                Form {
                    Text("This is reset time. This all routines unchecked at the time")
                    DatePicker("Reset Time", selection: $viewModel.resetTime, displayedComponents: .hourAndMinute)
                }

            }.padding()

            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
