import SwiftUI

struct ToDoListView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: ToDoViewModel
    @State private var newToDoTitle: String = ""
    @State private var newToDoEmoji: String = ""
    @State private var isEditMode: Bool = false

    let todoEmojis: [String] = ["😆", "🍔", "🍣", "🧹", "🚽", "💤", "☎️", "💊", "🏥", "💉"]

    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text("Your Routine").font(.title)
                    Text("All ToDos are unchecked every morning.")
                        .font(.subheadline)
                }.padding()
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
                Text("You Can Add Your Routine")
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
                                            .foregroundColor(viewModel.toDoList[index].isChecked ? .gray : colorScheme == .dark ? Color.white : Color.black)
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
