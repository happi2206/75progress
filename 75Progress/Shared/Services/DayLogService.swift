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
}
