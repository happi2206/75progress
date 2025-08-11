//
//  Milestone.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import Foundation

struct Milestone: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    var isCompleted: Bool
} 