//
//  DayStreak.swift
//  75Progress
//
//

import Foundation

final class DayStreak {
    static let shared = DayStreak()

    private init() {}

    private(set) var currentStreak: Int = 0

    func update(with streak: Int) {
        currentStreak = streak
    }
}
