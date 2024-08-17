//
//  SearchView.swift
//  daily-calender
//
//  Created by 金山功樹 on 2024/08/17.
//

import Foundation
import SwiftUI

struct SearchView: View {
    let notes: [Date: String]
    @State private var searchText = ""
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredNotes, id: \.key) { date, note in
                    VStack(alignment: .leading) {
                        Text(date, style: .date)
                            .font(.headline)
                        Text(note)
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Search Notes")
            .searchable(text: $searchText)
        }
    }
    
    private var filteredNotes: [(key: Date, value: String)] {
        if searchText.isEmpty {
            return Array(notes.sorted(by: { $0.key > $1.key }))
        } else {
            return notes.filter { $0.value.lowercased().contains(searchText.lowercased()) }
                .sorted(by: { $0.key > $1.key })
        }
    }
}

#Preview {
    SearchView(notes: [Date(): "Sample note", Date().addingTimeInterval(86400): "Another note"])
        .environmentObject(ThemeManager())
}
