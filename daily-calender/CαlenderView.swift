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
import Combine

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject private var viewModel: CalendarViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showingNoteEditor = false
    @State private var showingSearchView = false
    @State private var showingDetailedNoteEditor = false
    @State private var quickNote: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                VStack(spacing: geometry.size.height * 0.02) {
                    Text(viewModel.currentMonthYear)
                        .font(.custom("Avenir-Heavy", size: geometry.size.height * 0.03))
                        .padding(geometry.size.height * 0.01)
                        .background(Capsule().fill(themeManager.currentTheme.headerBackground))
                    
                    WeekdaysView()
                        .frame(height: geometry.size.height * 0.05)
                    
                    DaysGridView(showingNoteEditor: $showingNoteEditor)
                        .frame(height: geometry.size.height * 0.5)
                    
                    if let selectedDate = viewModel.selectedDate {
                        QuickNoteView(date: selectedDate, quickNote: $quickNote, showingDetailedNoteEditor: $showingDetailedNoteEditor)
                            .frame(height: geometry.size.height * 0.15)
                            .transition(.move(edge: .bottom))
                    }
                }
                .padding(.top, geometry.safeAreaInsets.top)
                
                Spacer()
                
//                NavigationControlView()
                    .frame(height: geometry.size.height * 0.08)
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
            }
            .padding(.horizontal, geometry.size.width * 0.05)
            .background(themeManager.currentTheme.background.edgesIgnoringSafeArea(.all))
        }
        .navigationBarItems(trailing: Button(action: { showingSearchView = true }) {
            Image(systemName: "magnifyingglass")
        })
        .navigationBarTitle("", displayMode: .inline)
        .sheet(isPresented: $showingDetailedNoteEditor) {
            if let selectedDate = viewModel.selectedDate {
                NoteEditorView(
                    date: selectedDate,
                    note: viewModel.notes[selectedDate]?.detailedNote ?? ""
                ) { newNote in
                    viewModel.saveDetailedNote(for: selectedDate, note: newNote)
                }
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

//private struct NavigationControlView: View {
//    @EnvironmentObject private var viewModel: CalendarViewModel
//    @EnvironmentObject private var themeManager: ThemeManager
//    
//    var body: some View {
//        HStack {
//            Button(action: viewModel.previousMonth) {
//                Image(systemName: "chevron.left")
//            }
//            Spacer()
//            Button(action: viewModel.nextMonth) {
//                Image(systemName: "chevron.right")
//            }
//        }
//        .padding()
//        .background(themeManager.currentTheme.navigationBackground)
//        .cornerRadius(10)
//        .foregroundColor(themeManager.currentTheme.darkText)
//    }
//}


struct QuickNoteView: View {
    let date: Date
    @Binding var quickNote: String
    @Binding var showingDetailedNoteEditor: Bool
    @EnvironmentObject private var viewModel: CalendarViewModel
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var isQuickNoteFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(date, style: .date)
                .font(.headline)
            
            TextField("Quick note (25 characters max)", text: $quickNote)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($isQuickNoteFocused)
                .onChange(of: quickNote) { _, newValue in
                    if newValue.count > 25 {
                        quickNote = String(newValue.prefix(25))
                    }
                    viewModel.saveQuickNote(for: date, note: quickNote)
                }
            
            if let detailedNote = viewModel.notes[date]?.detailedNote, !detailedNote.isEmpty {
                Text("つまびらか:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text(detailedNote)
                    .font(.subheadline)
                    .lineLimit(3)
                    .truncationMode(.tail)
            }
            
            Button(action: {
                showingDetailedNoteEditor = true
            }) {
                Text("編集")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
        .padding(.horizontal)
        .padding(.bottom, keyboardHeight)
        .animation(.easeOut(duration: 0.16), value: keyboardHeight)
        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
        .onTapGesture {
            isQuickNoteFocused = false
        }
        
    }
    
}

#Preview {
    CalendarView()
        .environmentObject(CalendarViewModel())
        .environmentObject(ThemeManager())
}
