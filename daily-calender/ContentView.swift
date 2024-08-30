import SwiftUI

struct ContentView: View {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var viewModel: CalendarViewModel

    init() {
        let themeManager = ThemeManager()
        self._themeManager = StateObject(wrappedValue: themeManager)
        self._viewModel = StateObject(wrappedValue: CalendarViewModel(themeManager: themeManager))
    }

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
