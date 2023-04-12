import SwiftUI


struct SettingsView: View {
    @ObservedObject var viewModel: ToDoViewModel
    
    var body: some View {
        VStack {
            Form {
                Text("This is reset time. This all routines unchecked at the time")
                DatePicker("Reset Time", selection: $viewModel.resetTime, displayedComponents: .hourAndMinute)
            }
            Form{
                Text("Dear My Grand Mother").font(.largeTitle)
                Text("I will send this app to my grandmother who has dementia. Her dementia has worsened since this year. She asks, “Have I had lunch yet?” after eating lunch and says, “I feel sick because I didn’t take a bath today,” after taking a bath. She has been struggling with this issue. Normal to-do apps have too much information for her. What she needs is to see only one to-do task at a time, and it would be better if it is displayed in large letters. I believe that this app will improve her life.")
            }
            Spacer()
        }
    }
}
