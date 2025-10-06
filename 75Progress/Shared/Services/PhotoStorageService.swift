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
    func uploadProgressPhoto(_ image: UIImage, for date: Date, uid: String) async throws -> URL
}

final class PhotoStorageService: PhotoStorageServing {
    private let storage = Storage.storage()

    func uploadProgressPhoto(_ image: UIImage, for date: Date, uid: String) async throws -> URL {
        let data = image.jpegData(compressionQuality: 0.85) ?? Data()
        let dateISO = ISODate.string(from: date)
        let path = "users/\(uid)/dayLogs/\(dateISO)/progress-\(UUID().uuidString).jpg"
        let ref = storage.reference(withPath: path)

        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"

        _ = try await ref.putDataAsync(data, metadata: meta)
        return try await ref.downloadURL()
    }
}
