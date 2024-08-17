//
//  NoteEditorView.swift
//  daily-calender
//
//  Created by 金山功樹 on 2024/08/17.
//

import Foundation
import SwiftUI

struct NoteEditorView: View {
    let date: Date
    @State private var note: String
    let onSave: (Date, String) -> Void
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var themeManager: ThemeManager
    
    init(date: Date, note: String, onSave: @escaping (Date, String) -> Void) {
        self.date = date
        self._note = State(initialValue: note)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.currentTheme.background.ignoresSafeArea()
                
                VStack {
                    TextField("Enter note (25 characters max)", text: $note)
                        .font(.custom("Avenir-Book", size: 16))
                        .padding()
                        .background(themeManager.currentTheme.inputBackground)
                        .cornerRadius(10)
                        .foregroundColor(themeManager.currentTheme.darkText)
                        .onChange(of: note) { _, newValue in
                            if newValue.count > 25 {
                                note = String(newValue.prefix(25))
                            }
                        }
                        .padding()
                    
                    Spacer()
                }
            }
            .navigationBarTitle(Text(date, style: .date), displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                onSave(date, note)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    NoteEditorView(date: Date(), note: "Sample note") { _, _ in }
        .environmentObject(ThemeManager())
}
