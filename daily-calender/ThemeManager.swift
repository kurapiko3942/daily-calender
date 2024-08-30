///
//  ThemeManager.swift
//  daily-calender
//
//  Created by 金山功樹 on 2024/08/17.
//
//
//  ThemeManager.swift
//  daily-calender
//
//  Created by 金山功樹 on 2024/08/17.
//

import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    @Published private(set) var currentTheme: CalendarTheme
    @Published private var currentMonth: Int

    private var cancellables = Set<AnyCancellable>()

    init() {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())
        self.currentMonth = month
        self.currentTheme = Self.themeForMonth(month)
        setupMonthObserver()
    }

    private func setupMonthObserver() {
        $currentMonth
            .sink { [weak self] newMonth in
                self?.updateThemeIfNeeded(for: newMonth)
            }
            .store(in: &cancellables)
    }

    private func updateThemeIfNeeded(for month: Int) {
        let newTheme = Self.themeForMonth(month)
        if type(of: newTheme) != type(of: currentTheme) {
            currentTheme = newTheme
        }
    }

    static func themeForMonth(_ month: Int) -> CalendarTheme {
        switch month {
        case 3...5:
            return SpringTheme()
        case 6...8:
            return SummerTheme()
        case 9...11:
            return AutumnTheme()
        default:
            return WinterTheme()
        }
    }

    func updateCurrentMonth(_ date: Date) {
        let calendar = Calendar.current
        let newMonth = calendar.component(.month, from: date)
        if newMonth != currentMonth {
            currentMonth = newMonth
            updateThemeIfNeeded(for: newMonth)
        }
    }

    var themeType: ThemeType {
        switch currentTheme {
        case is SpringTheme: return .spring
        case is SummerTheme: return .summer
        case is AutumnTheme: return .autumn
        case is WinterTheme: return .winter
        default: return .winter
        }
    }
}

enum ThemeType: Equatable {
    case spring, summer, autumn, winter
}

protocol CalendarTheme {
    var background: Color { get }
    var headerBackground: Color { get }
    var navigationBackground: Color { get }
    var normalDate: Color { get }
    var selectedDate: Color { get }
    var today: Color { get }
    var accent: Color { get }
    var darkText: Color { get }
    var dateBorder: Color { get }
    var inputBackground: Color { get }
}

struct SpringTheme: CalendarTheme {
    let background = Color(#colorLiteral(red: 1, green: 0.9764705882, blue: 0.9803921569, alpha: 1)) // 薄いピンク
    let headerBackground = Color(#colorLiteral(red: 0.9882352941, green: 0.8, blue: 0.8235294118, alpha: 1)) // 桜の花びらのピンク
    let navigationBackground = Color(#colorLiteral(red: 0.9607843137, green: 0.8784313725, blue: 0.8901960784, alpha: 1)) // 薄いピンク
    let normalDate = Color(#colorLiteral(red: 1, green: 0.9568627451, blue: 0.9607843137, alpha: 1)) // かなり薄いピンク
    let selectedDate = Color(#colorLiteral(red: 0.9450980392, green: 0.5882352941, blue: 0.6156862745, alpha: 1)) // 濃いめのピンク
    let today = Color(#colorLiteral(red: 0.9764705882, green: 0.7098039216, blue: 0.7333333333, alpha: 1)) // 中間的なピンク
    let accent = Color(#colorLiteral(red: 0.8980392157, green: 0.4666666667, blue: 0.4980392157, alpha: 1)) // アクセントとなる濃いピンク
    let darkText = Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)) // ダークグレー
    let dateBorder = Color(#colorLiteral(red: 0.9607843137, green: 0.8784313725, blue: 0.8901960784, alpha: 1)) // 薄いピンク
    let inputBackground = Color(#colorLiteral(red: 1, green: 0.9882352941, blue: 0.9882352941, alpha: 1)) // ほぼ白
}

struct SummerTheme: CalendarTheme {
    let background = Color(#colorLiteral(red: 0.9411764706, green: 0.9764705882, blue: 1, alpha: 1)) // 薄い空色
    let headerBackground = Color(#colorLiteral(red: 0.2196078431, green: 0.6, blue: 0.8588235294, alpha: 1)) // 濃い海色
    let navigationBackground = Color(#colorLiteral(red: 0.4, green: 0.7607843137, blue: 0.9647058824, alpha: 1)) // 明るい海色
    let normalDate = Color(#colorLiteral(red: 1, green: 1, blue: 0.9607843137, alpha: 1)) // 薄い砂色
    let selectedDate = Color(#colorLiteral(red: 0, green: 0.4980392157, blue: 0.7607843137, alpha: 1)) // 濃い青
    let today = Color(#colorLiteral(red: 0.2862745098, green: 0.8431372549, blue: 0.9450980392, alpha: 1)) // 明るい青
    let accent = Color(#colorLiteral(red: 1, green: 0.7843137255, blue: 0.3254901961, alpha: 1)) // 太陽を思わせる黄色
    let darkText = Color(#colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)) // ほぼ黒
    let dateBorder = Color(#colorLiteral(red: 0.7137254902, green: 0.8784313725, blue: 0.9568627451, alpha: 1)) // 薄い青
    let inputBackground = Color(#colorLiteral(red: 0.9764705882, green: 0.9921568627, blue: 1, alpha: 1)) // 非常に薄い青
}

struct AutumnTheme: CalendarTheme {
    let background = Color(#colorLiteral(red: 0.9647058824, green: 0.9137254902, blue: 0.8470588235, alpha: 1))
    let headerBackground = Color(#colorLiteral(red: 0.8470588235, green: 0.5215686275, blue: 0.2549019608, alpha: 1))
    let navigationBackground = Color(#colorLiteral(red: 0.9215686275, green: 0.6549019608, blue: 0.3882352941, alpha: 1))
    let normalDate = Color(#colorLiteral(red: 0.9882352941, green: 0.9254901961, blue: 0.8470588235, alpha: 1))
    let selectedDate = Color(#colorLiteral(red: 0.7411764706, green: 0.3137254902, blue: 0.1176470588, alpha: 1))
    let today = Color(#colorLiteral(red: 0.8784313725, green: 0.5215686275, blue: 0.2549019608, alpha: 1))
    let accent = Color(#colorLiteral(red: 0.6, green: 0.2509803922, blue: 0.1058823529, alpha: 1))
    let darkText = Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))
    let dateBorder = Color(#colorLiteral(red: 0.9215686275, green: 0.6549019608, blue: 0.3882352941, alpha: 1))
    let inputBackground = Color(#colorLiteral(red: 1, green: 0.9607843137, blue: 0.9019607843, alpha: 1))
}

struct WinterTheme: CalendarTheme {
    let background = Color(#colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9647058824, alpha: 1))
    let headerBackground = Color(#colorLiteral(red: 0.5254901961, green: 0.6980392157, blue: 0.8, alpha: 1))
    let navigationBackground = Color(#colorLiteral(red: 0.6666666667, green: 0.8, blue: 0.8784313725, alpha: 1))
    let normalDate = Color(#colorLiteral(red: 0.9411764706, green: 0.9607843137, blue: 0.9882352941, alpha: 1))
    let selectedDate = Color(#colorLiteral(red: 0.1882352941, green: 0.4666666667, blue: 0.6745098039, alpha: 1))
    let today = Color(#colorLiteral(red: 0.3882352941, green: 0.6, blue: 0.7411764706, alpha: 1))
    let accent = Color(#colorLiteral(red: 0.1529411765, green: 0.3882352941, blue: 0.5607843137, alpha: 1))
    let darkText = Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))
    let dateBorder = Color(#colorLiteral(red: 0.6666666667, green: 0.8, blue: 0.8784313725, alpha: 1))
    let inputBackground = Color(#colorLiteral(red: 0.9607843137, green: 0.9764705882, blue: 1, alpha: 1))
}
