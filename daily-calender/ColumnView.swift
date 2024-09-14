import SwiftUI

struct ColumnView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedFeature: String?
    
    let features = [
        Feature(icon: "lightbulb", title: "開発秘話", description: "デイリーカレンダーは、日々の生活をより効率的に管理したいという思いから生まれました。開発チームの苦労や工夫、アイデアの源泉など、アプリ誕生の裏側をご紹介します。"),
        Feature(icon: "arrow.up.circle", title: "今後のアップデート", description: "ユーザーの皆様のフィードバックを元に、常に進化し続けるデイリーカレンダー。近日公開予定の新機能や改善点をいち早くお知らせします。"),
        Feature(icon: "person.3", title: "グループ概要", description: "デイリーカレンダーを作り上げた個性豊かなチームメンバーをご紹介。それぞれの専門性や役割、チームとしての目標をお伝えします。")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                headerView
                featuresGrid
            }
            .padding()
        }
        .background(themeManager.currentTheme.background)
        .navigationTitle("アプリについて")
    }
    
    private var headerView: some View {
        VStack(spacing: 15) {
            Image(systemName: "calendar.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(themeManager.currentTheme.accent)
            
            Text("デイリーカレンダー")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(themeManager.currentTheme.darkText)
            
            Text("効率的な予定管理で、あなたの毎日をサポート")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(themeManager.currentTheme.darkText.opacity(0.7))
                .padding(.horizontal)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(themeManager.currentTheme.headerBackground))
        .shadow(radius: 5)
    }
    
    private var featuresGrid: some View {
        VStack(spacing: 20) {
            ForEach(features) { feature in
                FeatureCard(feature: feature, isSelected: selectedFeature == feature.title, theme: themeManager.currentTheme)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedFeature = (selectedFeature == feature.title) ? nil : feature.title
                        }
                    }
            }
        }
    }
}

struct Feature: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

struct FeatureCard: View {
    let feature: Feature
    let isSelected: Bool
    let theme: CalendarTheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: feature.icon)
                    .font(.title)
                    .foregroundColor(theme.accent)
                
                Text(feature.title)
                    .font(.headline)
                    .foregroundColor(theme.darkText)
            }
            
            if isSelected {
                Text(feature.description)
                    .font(.subheadline)
                    .foregroundColor(theme.darkText.opacity(0.7))
                    .padding(.top, 5)
                    .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(theme.normalDate))
        .shadow(radius: 3)
    }
}

struct ColumnView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ColumnView()
                .environmentObject(ThemeManager())
        }
    }
}
