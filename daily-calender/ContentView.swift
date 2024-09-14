import SwiftUI

struct ContentView: View {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var viewModel: CalendarViewModel
    @State private var showTutorial = false
    
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
                SettingsView()
                    .environmentObject(themeManager)
            }
            .tabItem {
                Label("設定", systemImage: "gear")
            }
            
            NavigationView {
                ColumnView()
                    .environmentObject(themeManager)
            }
            .tabItem {
                Label("コラム", systemImage: "newspaper")
            }
        }
        .onAppear {
            if !UserDefaults.standard.bool(forKey: "hasSeenTutorial") {
                showTutorial = true
            }
        }
        .fullScreenCover(isPresented: $showTutorial) {
            TutorialView(isPresented: $showTutorial)
        }
    }
}

// プレビュー用の構造体
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
