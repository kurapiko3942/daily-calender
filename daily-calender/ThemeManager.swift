//
//  ThemeManager.swift
//  daily-calender
//
//  Created by 金山功樹 on 2024/08/17.
//

import Foundation
import SwiftUI

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

class ThemeManager: ObservableObject {
    @Published var currentTheme: CalendarTheme
    
    private let themes: [Season: CalendarTheme] = [
        .spring: SpringTheme(),
        .summer: SummerTheme(),
        .autumn: AutumnTheme(),
        .winter: WinterTheme()
    ]
    
    init() {
        let currentSeason = Season.current
        self.currentTheme = themes[currentSeason]!
    }
    
    func updateTheme() {
        let currentSeason = Season.current
        self.currentTheme = themes[currentSeason]!
    }
}

enum Season: String, CaseIterable {
    case spring, summer, autumn, winter
    
    static var current: Season {
        let month = Calendar.current.component(.month, from: Date())
        switch month {
        case 3...5: return .spring
        case 6...8: return .summer
        case 9...11: return .autumn
        default: return .winter
        }
    }
}

struct SpringTheme: CalendarTheme {
    let background = Color(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.862745098, alpha: 1))
    let headerBackground = Color(#colorLiteral(red: 0.7411764706, green: 0.8784313725, blue: 0.7411764706, alpha: 1))
    let navigationBackground = Color(#colorLiteral(red: 0.8, green: 0.8980392157, blue: 0.8, alpha: 1))
    let normalDate = Color(#colorLiteral(red: 0.9215686275, green: 0.9607843137, blue: 0.8823529412, alpha: 1))
    let selectedDate = Color(#colorLiteral(red: 0.4941176471, green: 0.7450980392, blue: 0.2980392157, alpha: 1))
    let today = Color(#colorLiteral(red: 0.7058823529, green: 0.8392156863, blue: 0.5490196078, alpha: 1))
    let accent = Color(#colorLiteral(red: 0.3411764706, green: 0.6235294118, blue: 0.1647058824, alpha: 1))
    let darkText = Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))
    let dateBorder = Color(#colorLiteral(red: 0.8, green: 0.8980392157, blue: 0.8, alpha: 1))
    let inputBackground = Color(#colorLiteral(red: 1, green: 1, blue: 0.9411764706, alpha: 1))
}

struct SummerTheme: CalendarTheme {
    let background = Color(#colorLiteral(red: 0.9647058824, green: 0.9411764706, blue: 0.8470588235, alpha: 1))
    let headerBackground = Color(#colorLiteral(red: 0.9411764706, green: 0.7019607843, blue: 0.3333333333, alpha: 1))
    let navigationBackground = Color(#colorLiteral(red: 0.9607843137, green: 0.8, blue: 0.4666666667, alpha: 1))
    let normalDate = Color(#colorLiteral(red: 1, green: 0.9607843137, blue: 0.8823529412, alpha: 1))
    let selectedDate = Color(#colorLiteral(red: 0.9764705882, green: 0.5882352941, blue: 0.1137254902, alpha: 1))
    let today = Color(#colorLiteral(red: 0.9882352941, green: 0.7568627451, blue: 0.3137254902, alpha: 1))
    let accent = Color(#colorLiteral(red: 0.9529411765, green: 0.4588235294, blue: 0.1411764706, alpha: 1))
    let darkText = Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))
    let dateBorder = Color(#colorLiteral(red: 0.9607843137, green: 0.8, blue: 0.4666666667, alpha: 1))
    let inputBackground = Color(#colorLiteral(red: 1, green: 0.9803921569, blue: 0.9215686275, alpha: 1))
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
