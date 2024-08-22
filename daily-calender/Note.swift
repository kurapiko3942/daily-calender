//
//  Note.swift
//  daily-calender
//
//  Created by 金山功樹 on 2024/08/22.
//

import Foundation


struct Note: Codable, Identifiable {
    var id: UUID
    var quickNote: String
    var detailedNote: String
    var date: Date
    
    init(id: UUID = UUID(), quickNote: String = "", detailedNote: String = "", date: Date) {
        self.id = id
        self.quickNote = quickNote
        self.detailedNote = detailedNote
        self.date = date
    }
}
