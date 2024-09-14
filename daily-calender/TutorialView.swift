///
//  TutorialView.swift
//  daily-calender
//
//  Created by 金山功樹 on 2024/09/13.
//

import SwiftUI

struct TutorialView: View {
    @Binding var isPresented: Bool
    @StateObject private var pageManager = PageManager(pages: Self.tutorialPages)

    private static let tutorialPages: [TutorialPage] = [
        TutorialPage(title: "カレンダービュー", description: "月単位で予定を確認・管理できます。日付をタップして詳細を表示しましょう。", imageName: "calendar"),
        TutorialPage(title: "クイックノート", description: "素早くメモを取れます。長押しで詳細な編集も可能です。", imageName: "square.and.pencil"),
        TutorialPage(title: "テーマ設定", description: "お好みの色やスタイルを選んでカスタマイズできます。", imageName: "paintpalette"),
        TutorialPage(title: "始めましょう！", description: "デイリーカレンダーで効率的に予定を管理しましょう。", imageName: "hand.wave")
    ]

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                PageView(pageManager: pageManager)
                    .frame(height: 600)
                    .background(Color.white)
                    .cornerRadius(20)

                Button(action: {
                    if pageManager.currentPage < Self.tutorialPages.count - 1 {
                        pageManager.currentPage += 1
                    } else {
                        isPresented = false
                        UserDefaults.standard.set(true, forKey: "hasSeenTutorial")
                    }
                }) {
                    Text(pageManager.currentPage < Self.tutorialPages.count - 1 ? "次へ" : "始める")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()

                Spacer()
            }
            .padding()
        }
    }
}

struct TutorialPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

class PageManager: ObservableObject {
    @Published var currentPage: Int
    let pages: [TutorialPage]

    init(pages: [TutorialPage]) {
        self.currentPage = 0
        self.pages = pages
    }
}

struct PageView: View {
    @ObservedObject var pageManager: PageManager

    var body: some View {
        TabView(selection: $pageManager.currentPage) {
            ForEach(0..<pageManager.pages.count, id: \.self) { index in
                TutorialPageView(page: pageManager.pages[index])
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct TutorialPageView: View {
    let page: TutorialPage

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: page.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)

            Text(page.title)
                .font(.title)
                .fontWeight(.bold)

            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

struct TutorialPreviews: PreviewProvider {
    static var previews: some View {
        TutorialView(isPresented: .constant(true))
    }
}
