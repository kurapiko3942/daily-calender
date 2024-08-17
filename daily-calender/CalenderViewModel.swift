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
    @Published var notes: [Date: String] = [:]
    
    let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
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
    
    func saveNote(for date: Date, note: String) {
        if !note.isEmpty {
            notes[date] = note
        } else {
            notes.removeValue(forKey: date)
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
}
