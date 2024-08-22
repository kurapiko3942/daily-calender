//
//  NoteEditorView.swift
//  daily-calender
//
//  Created by 金山功樹 on 2024/08/17.
//

import SwiftUI

struct NoteEditorView: View {
    let date: Date
    @State private var note: String
    @State private var isHaikuMode: Bool
    @State private var haikuFirst: String = ""
    @State private var haikuSecond: String = ""
    @State private var haikuThird: String = ""
    @State private var hasChanges: Bool = false
    let onSave: (String) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    init(date: Date, note: String, onSave: @escaping (String) -> Void) {
        self.date = date
        self._note = State(initialValue: note)
        self.onSave = onSave
        
        // 既存のノートが俳句形式かどうかを判断
        if note.contains(" / ") {
            self._isHaikuMode = State(initialValue: true)
            let components = note.components(separatedBy: " / ")
            self._haikuFirst = State(initialValue: components.count > 0 ? components[0] : "")
            self._haikuSecond = State(initialValue: components.count > 1 ? components[1] : "")
            self._haikuThird = State(initialValue: components.count > 2 ? components[2] : "")
        } else {
            self._isHaikuMode = State(initialValue: false)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Input Mode", selection: $isHaikuMode) {
                    Text("25 Characters").tag(false)
                    Text("Haiku").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if isHaikuMode {
                    VStack(spacing: 10) {
                        HaikuTextField(placeholder: "5 syllables", text: $haikuFirst, limit: 5, hasChanges: $hasChanges)
                        HaikuTextField(placeholder: "7 syllables", text: $haikuSecond, limit: 7, hasChanges: $hasChanges)
                        HaikuTextField(placeholder: "5 syllables", text: $haikuThird, limit: 5, hasChanges: $hasChanges)
                    }
                } else {
                    TextField("Enter note (25 characters max)", text: $note)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: note) { _, newValue in
                            if newValue.count > 25 {
                                note = String(newValue.prefix(25))
                            }
                            hasChanges = true
                        }
                }
            }
            .padding()
            .navigationBarTitle(Text(date, style: .date), displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveAndDismiss()
                }
            )
        }
    }
    
    private func saveAndDismiss() {
        if hasChanges {
            if isHaikuMode {
                let haikuNote = "\(haikuFirst) / \(haikuSecond) / \(haikuThird)"
                onSave(haikuNote)
            } else {
                onSave(note)
            }
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct HaikuTextField: View {
    let placeholder: String
    @Binding var text: String
    let limit: Int
    @Binding var hasChanges: Bool
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: text) { _, newValue in
                    if newValue.count > limit {
                        text = String(newValue.prefix(limit))
                    }
                    hasChanges = true
                }
            Text("\(text.count)/\(limit)")
                .foregroundColor(text.count == limit ? .green : .gray)
        }
    }
}
