//
//  DayEntry.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import Foundation

struct DayEntry: Identifiable, Hashable {
    var id: UUID
    var date: Date
    var photos: [PhotoItem]
    var notes: [UUID: String] // photoId: note
    var summary: String?
    var isComplete: Bool
    
    init(id: UUID = UUID(), date: Date, photos: [PhotoItem] = [], notes: [UUID: String] = [:], summary: String? = nil, isComplete: Bool = false) {
        self.id = id
        self.date = date
        self.photos = photos
        self.notes = notes
        self.summary = summary
        self.isComplete = isComplete
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: DayEntry, rhs: DayEntry) -> Bool {
        lhs.id == rhs.id
    }
} 