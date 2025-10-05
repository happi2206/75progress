//
//  UserProfileRepository.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

protocol UserProfileRepositoryProtocol {
    func fetchUserProfile() -> AnyPublisher<UserProfile?, AppError>
    func upsertUserProfile(_ profile: UserProfile) -> AnyPublisher<UserProfile, AppError>
    func signInAnonymously() -> AnyPublisher<String, AppError>
    func loadProfileLocally() -> UserProfile?
}

class UserProfileRepository: UserProfileRepositoryProtocol {
    private let firestore = Firestore.firestore()
    private let auth = Auth.auth()
    
    // MARK: - Authentication
    
    func signInAnonymously() -> AnyPublisher<String, AppError> {
        Future<String, AppError> { promise in
            print("🔐 Attempting anonymous sign-in...")
            self.auth.signInAnonymously { result, error in
                if let error = error {
                    print("❌ Anonymous sign-in failed: \(error.localizedDescription)")
                    promise(.failure(.authenticationError(error.localizedDescription)))
                } else if let user = result?.user {
                    print("✅ Anonymous sign-in successful: \(user.uid)")
                    promise(.success(user.uid))
                } else {
                    print("❌ Anonymous sign-in failed: No user returned")
                    promise(.failure(.authenticationError("Failed to sign in anonymously")))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - User Profile Operations
    
    func fetchUserProfile() -> AnyPublisher<UserProfile?, AppError> {
        guard let currentUser = auth.currentUser else {
            return Just(nil)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        }
        
        return Future<UserProfile?, AppError> { promise in
            self.firestore.collection("users").document(currentUser.uid).getDocument { document, error in
                if let error = error {
                    promise(.failure(.networkError(error.localizedDescription)))
                } else if let document = document, document.exists {
                    do {
                        let profile = try document.data(as: UserProfile.self)
                        promise(.success(profile))
                    } catch {
                        promise(.failure(.persistenceError("Failed to decode user profile")))
                    }
                } else {
                    promise(.success(nil))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func upsertUserProfile(_ profile: UserProfile) -> AnyPublisher<UserProfile, AppError> {
        guard let currentUser = auth.currentUser else {
            return Fail(error: .authenticationError("User not authenticated"))
                .eraseToAnyPublisher()
        }
        
        return Future<UserProfile, AppError> { promise in
            let data: [String: Any] = [
                "id": profile.id.uuidString,
                "name": profile.name,
                "email": profile.email,
                "currentStreak": profile.currentStreak,
                "totalDays": profile.totalDays,
                "completedChallenges": profile.completedChallenges,
                "displayName": profile.displayName ?? "",
                "goals": profile.goals,
                "createdAt": Timestamp(date: profile.createdAt),
                "lastUpdated": Timestamp(date: profile.lastUpdated),
                "deviceID": profile.deviceID ?? ""
            ]
            
            print("💾 Saving profile to Firestore: \(currentUser.uid)")
            self.firestore.collection("users").document(currentUser.uid).setData(data) { error in
                if let error = error {
                    print("❌ Firestore save failed: \(error.localizedDescription)")
                    promise(.failure(.networkError(error.localizedDescription)))
                } else {
                    print("✅ Firestore save successful")
                    // Also save locally
                    self.saveProfileLocally(profile)
                    promise(.success(profile))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Local Storage
    
    private func saveProfileLocally(_ profile: UserProfile) {
        do {
            let data = try JSONEncoder().encode(profile)
            UserDefaults.standard.set(data, forKey: "user_profile")
        } catch {
            print("Failed to save profile locally: \(error)")
        }
    }
    
    func loadProfileLocally() -> UserProfile? {
        guard let data = UserDefaults.standard.data(forKey: "user_profile") else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(UserProfile.self, from: data)
        } catch {
            print("Failed to load profile locally: \(error)")
            return nil
        }
    }
}

// MARK: - UserProfile Extensions for Firestore

extension UserProfile {
    var firestoreData: [String: Any] {
        return [
            "id": id.uuidString,
            "name": name,
            "email": email,
            "currentStreak": currentStreak,
            "totalDays": totalDays,
            "completedChallenges": completedChallenges,
            "displayName": displayName ?? "",
            "goals": goals,
            "createdAt": createdAt.timeIntervalSince1970,
            "lastUpdated": lastUpdated.timeIntervalSince1970,
            "deviceID": deviceID ?? ""
        ]
    }
    
    init?(from firestoreData: [String: Any]) {
        guard let idString = firestoreData["id"] as? String,
              let id = UUID(uuidString: idString),
              let name = firestoreData["name"] as? String,
              let email = firestoreData["email"] as? String,
              let currentStreak = firestoreData["currentStreak"] as? Int,
              let totalDays = firestoreData["totalDays"] as? Int,
              let completedChallenges = firestoreData["completedChallenges"] as? Int else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.email = email
        self.currentStreak = currentStreak
        self.totalDays = totalDays
        self.completedChallenges = completedChallenges
        self.displayName = firestoreData["displayName"] as? String
        self.goals = firestoreData["goals"] as? [String] ?? []
        self.createdAt = Date(timeIntervalSince1970: firestoreData["createdAt"] as? TimeInterval ?? 0)
        self.lastUpdated = Date(timeIntervalSince1970: firestoreData["lastUpdated"] as? TimeInterval ?? 0)
        self.deviceID = firestoreData["deviceID"] as? String
    }
}
