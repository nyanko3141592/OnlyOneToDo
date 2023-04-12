import Combine
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @StateObject var viewModel = ToDoViewModel()
    private let tabSelectionSubject = CurrentValueSubject<Int, Never>(0)

    var body: some View {
        TabView(selection: $selectedTab) {
            MainView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("To-Do List")
                }.tag(0)
                .onReceive(tabSelectionSubject) { _ in
                    if selectedTab == 0 {
                        viewModel.updateCardViewUncheckedItem()
                    }
                }
            ToDoListView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("routine")
                }.tag(1)

            SettingsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }.tag(2)
        }.onChange(of: selectedTab) { newValue in
            tabSelectionSubject.send(newValue)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
