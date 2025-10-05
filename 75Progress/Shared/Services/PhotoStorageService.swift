//
//  PhotoStorageService.swift
//  75Progress
//
//  Created by Happiness Adeboye on 2/10/2025.
//


import Foundation
import UIKit
import FirebaseStorage

protocol PhotoStorageServing {
    /// Uploads a progress photo for a given day and returns a download URL.
    func uploadProgressPhoto(_ image: UIImage, for date: Date, uid: String) async throws -> URL
}

final class PhotoStorageService: PhotoStorageServing {
    private let storage = Storage.storage()

    func uploadProgressPhoto(_ image: UIImage, for date: Date, uid: String) async throws -> URL {
        // 1) Resize a little & compress so uploads are fast (tweak as you like)
        let data = image.jpegData(compressionQuality: 0.85) ?? Data()
        // 2) yyyy-MM-dd key (e.g. 2025-10-04)
        let dateISO = ISODate.string(from: date)
        // 3) Path per-day; allow multiple photos/day by UUID
        let path = "users/\(uid)/dayLogs/\(dateISO)/progress-\(UUID().uuidString).jpg"
        let ref = storage.reference(withPath: path)

        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"

        _ = try await ref.putDataAsync(data, metadata: meta)
        return try await ref.downloadURL()
    }
}
