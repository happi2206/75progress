//
//  DayLogService.swift
//  75Progress
//
//  Created by Happiness Adeboye on 2/10/2025.
//

import Foundation
import FirebaseFirestore

protocol DayLogServing {
    func appendPhotoURL(_ url: URL, for date: Date, uid: String) async throws
    func setPhotoURL(_ url: URL, for itemKey: String, date: Date, uid: String) async throws
    func fetchPhotoURLs(for date: Date, uid: String) async throws -> [String: URL]
    func removePhoto(for itemKey: String, date: Date, uid: String) async throws
    func upsertDayLog(for date: Date, uid: String, summary: String?, isComplete: Bool, streak: Int?) async throws
}

final class DayLogService: DayLogServing {
    private let db = Firestore.firestore()

    func appendPhotoURL(_ url: URL, for date: Date, uid: String) async throws {
        let dateISO = ISODate.string(from: date)
        let doc = db.collection("users").document(uid)
            .collection("dayLogs").document(dateISO)

        try await doc.setData([
            "dateISO": dateISO,
            "photoURLs": FieldValue.arrayUnion([url.absoluteString]),
            "updatedAt": FieldValue.serverTimestamp()
        ], merge: true)
    }

    func setPhotoURL(_ url: URL, for itemKey: String, date: Date, uid: String) async throws {
        let dateISO = ISODate.string(from: date)
        let doc = db.collection("users").document(uid)
            .collection("dayLogs").document(dateISO)

        try await doc.setData([
            "dateISO": dateISO,
            "photoEntries.\(itemKey)": url.absoluteString,
            "updatedAt": FieldValue.serverTimestamp()
        ], merge: true)
    }

    func fetchPhotoURLs(for date: Date, uid: String) async throws -> [String: URL] {
        let dateISO = ISODate.string(from: date)
        let doc = db.collection("users").document(uid)
            .collection("dayLogs").document(dateISO)

        let snapshot = try await doc.getDocument()
        var result: [String: URL] = [:]

        if let data = snapshot.data() {
            if let entries = data["photoEntries"] as? [String: String] {
                for (key, value) in entries {
                    if let url = URL(string: value) {
                        result[key] = url
                    }
                }
            }

            if result.isEmpty, let legacy = data["photoURLs"] as? [String] {
                let legacyKeys = ["progress_pic", "workout_1", "workout_2", "reading", "water", "diet"]
                for (index, value) in legacy.enumerated() where index < legacyKeys.count {
                    if let url = URL(string: value) {
                        result[legacyKeys[index]] = url
                    }
                }
            }
        }

        return result
    }

    func removePhoto(for itemKey: String, date: Date, uid: String) async throws {
        let dateISO = ISODate.string(from: date)
        let doc = db.collection("users").document(uid)
            .collection("dayLogs").document(dateISO)

        try await doc.setData([
            "photoEntries.\(itemKey)": FieldValue.delete(),
            "updatedAt": FieldValue.serverTimestamp()
        ], merge: true)
    }

    func upsertDayLog(for date: Date, uid: String, summary: String?, isComplete: Bool, streak: Int?) async throws {
        let dateISO = ISODate.string(from: date)
        let doc = db.collection("users").document(uid)
            .collection("dayLogs").document(dateISO)

        var data: [String: Any] = [
            "dateISO": dateISO,
            "updatedAt": FieldValue.serverTimestamp(),
            "isComplete": isComplete
        ]

        if let summary = summary {
            data["summary"] = summary
        }

        if let streak = streak {
            data["currentStreak"] = streak
        }

        try await doc.setData(data, merge: true)
    }
}
