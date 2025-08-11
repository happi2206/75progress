//
//  Challenge.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import Foundation

struct Challenge: Identifiable {
    let id = UUID()
    let name: String
    var currentDay: Int
    let totalDays: Int
    var isActive: Bool
} 