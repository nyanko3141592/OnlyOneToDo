import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ToDoViewModel

    var body: some View {
        VStack {
            Form {
                Section {
                    Text("ToDo app for dementia).font(.title)
                    Text("My grandmother’s dementia has worsened since this year. After she eats lunch, she asks, “Have I had lunch yet?” and after taking a bath, she says, “I feel sick because I didn’t take a bath today.” She has been struggling with this issue. Normal to-do apps have too much information for her. What she needs to see is only one to-do task at a time, and it would be better if it is displayed in large letters. I believe that this app will improve her life.")
                    Spacer()
                } header: {
                    Text("What is this app")
                }
            }
        }
    }
}
