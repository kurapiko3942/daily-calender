//
//  CalenderViewModel.swift
//  daily-calender
//
//  Created by 金山功樹 on 2024/08/17.
//

import SwiftUI
import Foundation

class CalendarViewModel: ObservableObject {
    @Published var currentDate: Date {
        didSet {
            objectWillChange.send()
            themeManager.updateCurrentMonth(currentDate)
        }
    }
    @Published var selectedDate: Date? {
        didSet {
            print("ViewModel: selectedDate changed to \(selectedDate?.description ?? "nil")")
            objectWillChange.send()
        }
    }
    @Published var notes: [Date: Note] = [:]

    let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    @ObservedObject var themeManager: ThemeManager

    init(themeManager: ThemeManager) {
        self.themeManager = themeManager
        self.currentDate = Date()
        loadNotes()
        themeManager.updateCurrentMonth(self.currentDate)
    }

    var currentMonthYear: String {
        dateFormatter.string(from: currentDate)
    }

    var currentMonthYearJapanese: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy年M月"
        return dateFormatter.string(from: currentDate)
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

    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

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
            notes[date] = Note(quickNote: note, detailedNote: existingNote.detailedNote, date: date)
        } else {
            notes[date] = Note(quickNote: note, date: date)
        }
        saveNotes()
    }

    func saveDetailedNote(for date: Date, note: String) {
        if let existingNote = notes[date] {
            notes[date] = Note(quickNote: existingNote.quickNote, detailedNote: note, date: date)
        } else {
            notes[date] = Note(detailedNote: note, date: date)
        }
        saveNotes()
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

    func selectDate(_ date: Date) {
        print("Selecting date: \(date)")
        selectedDate = date
        objectWillChange.send()
    }

    // MARK: - Data Persistence

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
