import SwiftUI

struct SwipeCardView: View {
    let toDoItem: ToDoItem
    let onRemove: (SwipeDirection) -> Void
    let bounds = UIScreen.main.bounds

    @State private var translation: CGSize = .zero
    @State private var swipeStatus: SwipeStatus = .none

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(background)
                .shadow(radius: 4)

            VStack {
                Spacer()
                Text(toDoItem.title)
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
        }.padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .offset(x: translation.width, y: translation.height)
            .rotationEffect(rotationAngle)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        translation = value.translation
                        swipeStatus = .swiping(translation: value.translation)
                    }
                    .onEnded { value in
                        let direction = value.translation.width > 0 ? SwipeDirection.right : SwipeDirection.left
                        if abs(value.translation.width) > bounds.width / 2 - 30 {
                            swipeStatus = .swiped(direction)
                            translation = .zero
                            onRemove(direction)
                        } else {
                            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.7)) {
                                swipeStatus = .none
                                translation = .zero
                            }
                        }
                    }
            )
    }

    private var rotationAngle: Angle {
        if case .swiping(let translation) = swipeStatus {
            let rotation = Double(translation.width / 100)
            return Angle(degrees: rotation)
        } else {
            return .zero
        }
    }

    private var background: Color {
        switch swipeStatus {
        case .none:
            return .red
        case .swiping(let translation):
            if abs(translation.width) > bounds.width / 2 - 30 {
                return .blue
            }
            return .red
        case .swiped(let direction):
            return direction == .left ? .red : .green
        }
    }
}

extension SwipeCardView {
    enum SwipeStatus {
        case none
        case swiping(translation: CGSize)
        case swiped(SwipeDirection)
    }

    enum SwipeDirection {
        case left
        case right
    }
}

struct SwipeCardView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeCardView(toDoItem: ToDoItem(title: "Sample ToDo", isChecked: false), onRemove: { _ in })
    }
}
