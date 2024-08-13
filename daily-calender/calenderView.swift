//
//  calenderView.swift
//  daily-calender
//
//  Created by 金山功樹 on 2024/08/13.
//

import SwiftUI

struct CalendarView: View {
    @State private var currentDate = Date()
    @State private var notes: [Date: String] = [:]
    @State private var selectedDate: Date?
    @State private var showingNoteEditor = false
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack {
            Text(dateFormatter.string(from: currentDate))
                .font(.title)
                .padding()
            
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(days(), id: \.self) { date in
                    if let date = date {
                        Button(action: {
                            selectedDate = date
                            showingNoteEditor = true
                        }) {
                            VStack {
                                Text("\(self.calendar.component(.day, from: date))")
                                if notes[date] != nil {
                                    Image(systemName: "note.text")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .frame(height: 40)
                        .background(
                            Circle()
                                .fill(isSelectedDate(date) ? Color.green : (isToday(date) ? Color.blue : Color.clear))
                        )
                        .foregroundColor(isSelectedDate(date) || isToday(date) ? .white : .primary)
                    } else {
                        Text("")
                            .frame(height: 40)
                    }
                }
            }
            
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingNoteEditor) {
            if let selectedDate = selectedDate {
                NoteEditorView(
                    date: Binding(
                        get: { selectedDate },
                        set: { self.selectedDate = $0 }
                    ),
                    note: notes[selectedDate] ?? "",
                    onSave: { newNote in
                        if !newNote.isEmpty {
                            notes[selectedDate] = newNote
                        } else {
                            notes.removeValue(forKey: selectedDate)
                        }
                    }
                )
            }
        }
    }
    
    private func days() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentDate) else { return [] }
        let monthFirstWeekday = calendar.component(.weekday, from: monthInterval.start)
        let days = calendar.range(of: .day, in: .month, for: currentDate)!.count
        
        let leadingSpaces = monthFirstWeekday - 1
        let trailingSpaces = 7 - (leadingSpaces + days) % 7
        
        return (0..<leadingSpaces).map { _ in nil } +
               (0..<days).map { day in calendar.date(byAdding: .day, value: day, to: monthInterval.start)! } +
               (0..<trailingSpaces).map { _ in nil }
    }
    
    private func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
    
    private func isSelectedDate(_ date: Date) -> Bool {
        selectedDate.map { calendar.isDate($0, inSameDayAs: date) } ?? false
    }
    
    private func previousMonth() {
        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate)!
    }
    
    private func nextMonth() {
        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
    }
}

struct NoteEditorView: View {
    @Binding var date: Date
    @State private var note: String
    let onSave: (String) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    init(date: Binding<Date>, note: String, onSave: @escaping (String) -> Void) {
        self._date = date
        self._note = State(initialValue: note)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .onChange(of: date) { oldValue, newValue in
                        // 日付が変更されたときの処理をここに記述
                    }
                
                TextField("Enter note (25 characters max)", text: $note)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: note) { oldValue, newValue in
                        if newValue.count > 25 {
                            note = String(newValue.prefix(25))
                        }
                    }
                
                Spacer()
            }
            .navigationBarTitle(Text(date, style: .date), displayMode: .inline)
            .navigationBarItems(
                trailing: Button("Save") {
                    onSave(note)
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}
