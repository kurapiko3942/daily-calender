//
//  SearchView.swift
//  daily-calender
//
//  Created by 金山功樹 on 2024/08/17.
//

import SwiftUI

struct SearchView: View {
    let notes: [Date: Note]
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredNotes, id: \.key) { date, note in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(date, style: .date)
                            .font(.headline)
                        if !note.quickNote.isEmpty {
                            Text("Quick Note: \(note.quickNote)")
                                .font(.subheadline)
                        }
                        if !note.detailedNote.isEmpty {
                            Text("Detailed Note:")
                                .font(.subheadline)
                                .fontWeight(.bold)
                            Text(note.detailedNote)
                                .font(.subheadline)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Search Notes")
            .searchable(text: $searchText, prompt: "Search notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var filteredNotes: [(key: Date, value: Note)] {
        if searchText.isEmpty {
            return Array(notes.sorted(by: { $0.key > $1.key }))
        } else {
            return notes.filter { _, note in
                note.quickNote.lowercased().contains(searchText.lowercased()) ||
                note.detailedNote.lowercased().contains(searchText.lowercased())
            }
            .sorted(by: { $0.key > $1.key })
        }
    }
}
