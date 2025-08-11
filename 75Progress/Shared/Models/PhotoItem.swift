//
//  PhotoItem.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import Foundation

struct PhotoItem: Identifiable, Hashable {
    var id: UUID
    var url: URL
    var label: String
    
    init(id: UUID = UUID(), url: URL, label: String) {
        self.id = id
        self.url = url
        self.label = label
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: PhotoItem, rhs: PhotoItem) -> Bool {
        lhs.id == rhs.id
    }
} 