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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
