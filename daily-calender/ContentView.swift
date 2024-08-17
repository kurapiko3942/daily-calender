import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @StateObject private var themeManager = ThemeManager()

    var body: some View {
        CalendarView()
            .environmentObject(viewModel)
            .environmentObject(themeManager)
    }
}

#Preview {
    ContentView()
}

