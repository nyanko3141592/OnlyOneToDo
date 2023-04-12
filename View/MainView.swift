import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: ToDoViewModel
    let emojis: [String] = ["😀", "🙌", "😁", "😆", "🐟", "🤣", "😊", "😇", "🍙", "🍣", "🧹", "🚽", "💤", "☎️"]
    var body: some View {
        ZStack {
            if let todo = viewModel.cardViewUncheckedItem {
                SwipeCardView(toDoItem: todo, onRemove: { direction in
                    viewModel.processSwipeAction(todo: todo, direction: direction)
                })
                Spacer()
                VStack {
                    HStack {
                        Text("←Yet")
                            .font(.largeTitle)
                            .bold()
                            .padding()
                        Spacer()
                        Text("Done→")
                            .font(.largeTitle)
                            .bold()
                            .padding()
                    }.foregroundColor(.white).padding()
                    Spacer()
                }
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
