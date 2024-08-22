import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @StateObject private var themeManager = ThemeManager()

    var body: some View {
        TabView {
            NavigationView {
                CalendarView()
                    .environmentObject(viewModel)
                    .environmentObject(themeManager)
            }
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            
            NavigationView {
                Text("Second Tab Content")
                    .navigationTitle("Second Tab")
            }
            .tabItem {
                Label("Second", systemImage: "2.circle")
            }
        }
    }
}

#Preview {
    ContentView()
}

