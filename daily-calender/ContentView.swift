import SwiftUI

struct ContentView: View {
    // ThemeManager: アプリ全体のテーマ（色やスタイル）を管理
    @StateObject private var themeManager = ThemeManager()
    
    // CalendarViewModel: カレンダーのデータとロジックを管理
    @StateObject private var viewModel: CalendarViewModel
    
    // イニシャライザ: ViewModelの初期化
    init() {
        let themeManager = ThemeManager()
        self._themeManager = StateObject(wrappedValue: themeManager)
        self._viewModel = StateObject(wrappedValue: CalendarViewModel(themeManager: themeManager))
    }
    
    // ビューの本体
    var body: some View {
        TabView {
            // カレンダータブ
            NavigationView {
                CalendarView()
                    .environmentObject(viewModel)
                    .environmentObject(themeManager)
            }
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            
            // 設定タブ
            NavigationView {
                SettingsView()
                    .environmentObject(themeManager)
            }
            .tabItem {
                Label("設定", systemImage: "gear")
            }
        }
    }
}

// プレビュー用の構造体
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
