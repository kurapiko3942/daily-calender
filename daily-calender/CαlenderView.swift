//
//  CαlenderView.swift
//  daily-calender
//
//  Created by 金山功樹 on 2024/08/17.
//

//
//  CalendarView.swift
//  daily-calender
//
//  Created by 金山功樹 on 2024/08/17.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject private var viewModel: CalendarViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showingNoteEditor = false
    @State private var showingSearchView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.currentTheme.background
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text(viewModel.currentMonthYear)
                        .font(.custom("Avenir-Heavy", size: 24))
                        .padding()
                        .background(Capsule().fill(themeManager.currentTheme.headerBackground))
                    
                    WeekdaysView()
                    
                    DaysGridView(showingNoteEditor: $showingNoteEditor)
                    
                    NavigationControlView()
                }
                .padding()
            }
            .navigationBarItems(trailing: Button(action: { showingSearchView = true }) {
                Image(systemName: "magnifyingglass")
            })
        }
        .sheet(isPresented: $showingNoteEditor) {
            if let selectedDate = viewModel.selectedDate {
                NoteEditorView(date: selectedDate, note: viewModel.notes[selectedDate] ?? "",
                               onSave: viewModel.saveNote)
            }
        }
        .sheet(isPresented: $showingSearchView) {
            SearchView(notes: viewModel.notes)
        }
    }
}

private struct WeekdaysView: View {
    @EnvironmentObject private var viewModel: CalendarViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            ForEach(viewModel.weekdays, id: \.self) { day in
                Text(day)
                    .font(.custom("Avenir-Medium", size: 14))
                    .foregroundColor(themeManager.currentTheme.darkText)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

private struct DaysGridView: View {
    @EnvironmentObject private var viewModel: CalendarViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var showingNoteEditor: Bool
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
            ForEach(viewModel.days(), id: \.self) { date in
                if let date = date {
                    DayCellView(date: date, showingNoteEditor: $showingNoteEditor)
                } else {
                    Color.clear.frame(height: 50)
                }
            }
        }
    }
}

private struct DayCellView: View {
    let date: Date
    @Binding var showingNoteEditor: Bool
    @EnvironmentObject private var viewModel: CalendarViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: {
            viewModel.selectedDate = date
            showingNoteEditor = true
        }) {
            VStack {
                Text("\(viewModel.calendar.component(.day, from: date))")
                    .font(.custom("Avenir-Book", size: 16))
                    .frame(width: 30, height: 30)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(viewModel.dateBackgroundColor(for: date, theme: themeManager.currentTheme))
                    )
                if viewModel.notes[date] != nil {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 10))
                        .foregroundColor(themeManager.currentTheme.accent)
                }
            }
        }
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(themeManager.currentTheme.dateBorder, lineWidth: 1)
        )
        .foregroundColor(viewModel.dateTextColor(for: date, theme: themeManager.currentTheme))
    }
}

private struct NavigationControlView: View {
    @EnvironmentObject private var viewModel: CalendarViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Button(action: viewModel.previousMonth) {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Button(action: viewModel.nextMonth) {
                Image(systemName: "chevron.right")
            }
        }
        .padding()
        .background(themeManager.currentTheme.navigationBackground)
        .cornerRadius(10)
        .foregroundColor(themeManager.currentTheme.darkText)
    }
}

#Preview {
    CalendarView()
        .environmentObject(CalendarViewModel())
        .environmentObject(ThemeManager())
}
