
//
//  CalendarView.swift
//  daily-calender
//
//  Created by 金山功樹 on 2024/08/17.
//

import SwiftUI
import Combine

struct CalendarView: View {
    // 環境オブジェクト: ビューモデルとテーママネージャー
    @EnvironmentObject private var viewModel: CalendarViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    // UI状態を管理するための状態変数
    @State private var showingNoteEditor = false // ノートエディタの表示状態
    @State private var showingSearchView = false // 検索ビューの表示状態
    @State private var showingDetailedNoteEditor = false // 詳細ノートエディタの表示状態
    @State private var showingYearMonthPicker = false // 年月ピッカーの表示状態
    @State private var quickNote: String = "" // クイックノートの内容
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    VStack(spacing: geometry.size.height * 0.02) {
                        // 年月表示ボタン: タップで年月ピッカーを表示
                        Button(action: { showingYearMonthPicker = true }) {
                            Text(viewModel.currentMonthYearJapanese)
                                .font(.custom("Avenir-Heavy", size: geometry.size.height * 0.03))
                                .padding(geometry.size.height * 0.01)
                                .background(Capsule().fill(themeManager.currentTheme.headerBackground))
                        }
                        
                        // 曜日表示: 週の曜日を表示
                        WeekdaysView()
                            .frame(height: geometry.size.height * 0.05)
                        
                        // 日付グリッド: 月のカレンダーを表示
                        DaysGridView(showingNoteEditor: $showingNoteEditor)
                            .frame(height: geometry.size.height * 0.5)
                        
                        // クイックノート: 選択された日付がある場合に表示
                        if let selectedDate = viewModel.selectedDate {
                            QuickNoteView(date: selectedDate, quickNote: $quickNote, showingDetailedNoteEditor: $showingDetailedNoteEditor)
                                .frame(height: geometry.size.height * 0.15)
                                .transition(.move(edge: .bottom))
                        }
                    }
                    .padding(.top, geometry.safeAreaInsets.top)
                    
                    Spacer()
                }
                .padding(.horizontal, geometry.size.width * 0.05)
                
                // 年月ピッカー: showingYearMonthPickerがtrueの時に表示
                if showingYearMonthPicker {
                    YearMonthPickerView(date: $viewModel.currentDate, isPresented: $showingYearMonthPicker)
                        .background(Color.black.opacity(0.3))
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .background(themeManager.currentTheme.background.edgesIgnoringSafeArea(.all))
        }
        // ナビゲーションバーの設定: 検索ボタンを追加
        .navigationBarItems(trailing: Button(action: { showingSearchView = true }) {
            Image(systemName: "magnifyingglass")
        })
        .navigationBarTitle("", displayMode: .inline)
        // 詳細ノートエディタのシート表示
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
        // 検索ビューのシート表示
        .sheet(isPresented: $showingSearchView) {
            SearchView(notes: viewModel.notes)
        }
        // 選択された日付の変更を監視し、クイックノートを更新
        .onChange(of: viewModel.selectedDate) { _, newValue in
            print("Selected date changed to \(newValue?.description ?? "nil")")
            if let date = newValue {
                quickNote = viewModel.notes[date]?.quickNote ?? ""
            } else {
                quickNote = ""
            }
        }
    }
}

// 年月ピッカービュー: ユーザーが年と月を選択するためのビュー
struct YearMonthPickerView: View {
    @Binding var date: Date // 選択された日付
    @Binding var isPresented: Bool // ピッカーの表示状態
    @State private var selectedYear: Int // 選択された年
    @State private var selectedMonth: Int // 選択された月
    
    // イニシャライザ: 現在の日付から年と月を初期化
    init(date: Binding<Date>, isPresented: Binding<Bool>) {
        _date = date
        _isPresented = isPresented
        let calendar = Calendar.current
        _selectedYear = State(initialValue: calendar.component(.year, from: date.wrappedValue))
        _selectedMonth = State(initialValue: calendar.component(.month, from: date.wrappedValue))
    }
    
    var body: some View {
        VStack {
            HStack {
                // 年選択ピッカー
                Picker("年", selection: $selectedYear) {
                    ForEach((1970...2070), id: \.self) { year in
                        Text("\(year)年").tag(year)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)
                .clipped()
                
                // 月選択ピッカー
                Picker("月", selection: $selectedMonth) {
                    ForEach((1...12), id: \.self) { month in
                        Text("\(month)月").tag(month)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)
                .clipped()
            }
            .padding()
            
            HStack {
                // キャンセルボタン
                Button("キャンセル") {
                    isPresented = false
                }
                .padding()
                
                Spacer()
                
                // 決定ボタン: 選択された年月を適用
                Button("決定") {
                    let calendar = Calendar.current
                    if let newDate = calendar.date(from: DateComponents(year: selectedYear, month: selectedMonth)) {
                        date = newDate
                    }
                    isPresented = false
                }
                .padding()
            }
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding()
    }
}

// 曜日表示ビュー: 週の曜日を表示
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

// 日付グリッドビュー: 月のカレンダーを表示
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

// 日付セルビュー: 個々の日付を表示
private struct DayCellView: View {
    let date: Date
    @Binding var showingNoteEditor: Bool
    @EnvironmentObject private var viewModel: CalendarViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: {
            print("Date selected: \(date)")
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

// クイックノートビュー: 選択された日付のクイックノートを表示・編集
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

// プレビュー: SwiftUI プレビュー用のコード
#Preview {
    let themeManager = ThemeManager()
    let viewModel = CalendarViewModel(themeManager: themeManager)
    return CalendarView()
        .environmentObject(viewModel)
        .environmentObject(themeManager)
}
