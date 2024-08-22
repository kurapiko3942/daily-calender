//
//  CalenderViewModel.swift
//  daily-calender
//
//  Created by 金山功樹 on 2024/08/17.
//

import Foundation
import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var currentDate = Date()
    @Published var selectedDate: Date?
    @Published var notes: [Date: Note] = [:] {
        didSet {
            saveNotes()
        }
    }
    
    let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    init() {
        loadNotes()
    }
    
    var currentMonthYear: String {
        dateFormatter.string(from: currentDate)
    }
    
    var weekdays: [String] {
        calendar.shortWeekdaySymbols
    }
    
    func days() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentDate) else { return [] }
        let monthFirstWeekday = calendar.component(.weekday, from: monthInterval.start)
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentDate)!.count
        
        let leadingSpaces = monthFirstWeekday - 1
        let trailingSpaces = 7 - (leadingSpaces + daysInMonth) % 7
        
        return (0..<leadingSpaces).map { _ in nil } +
               (0..<daysInMonth).map { day in calendar.date(byAdding: .day, value: day, to: monthInterval.start)! } +
               (0..<trailingSpaces).map { _ in nil }
    }
    
    //
    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
    
    //
    func isSelectedDate(_ date: Date) -> Bool {
        selectedDate.map { calendar.isDate($0, inSameDayAs: date) } ?? false
    }
    
    func previousMonth() {
        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate)!
    }
    
    func nextMonth() {
        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
    }
    
    func saveQuickNote(for date: Date, note: String) {
            if let existingNote = notes[date] {
                notes[date] = Note(id: existingNote.id, quickNote: note, detailedNote: existingNote.detailedNote, date: date)
            } else {
                notes[date] = Note(quickNote: note, date: date)
            }
        }
        
        func saveDetailedNote(for date: Date, note: String) {
            if let existingNote = notes[date] {
                notes[date] = Note(id: existingNote.id, quickNote: existingNote.quickNote, detailedNote: note, date: date)
            } else {
                notes[date] = Note(detailedNote: note, date: date)
            }
        }
    
    func dateBackgroundColor(for date: Date, theme: CalendarTheme) -> Color {
        if isSelectedDate(date) {
            return theme.selectedDate
        } else if isToday(date) {
            return theme.today
        } else {
            return theme.normalDate
        }
    }
    
    func dateTextColor(for date: Date, theme: CalendarTheme) -> Color {
        if isSelectedDate(date) || isToday(date) {
            return .white
        } else {
            return theme.darkText
        }
    }
    
    private func saveNotes() {
            do {
                let data = try JSONEncoder().encode(notes)
                UserDefaults.standard.set(data, forKey: "savedNotes")
            } catch {
                print("Failed to save notes: \(error.localizedDescription)")
            }
        }
        
        private func loadNotes() {
            guard let data = UserDefaults.standard.data(forKey: "savedNotes") else { return }
            do {
                let decodedNotes = try JSONDecoder().decode([Date: Note].self, from: data)
                notes = decodedNotes
            } catch {
                print("Failed to load notes: \(error.localizedDescription)")
            }
        }
}
