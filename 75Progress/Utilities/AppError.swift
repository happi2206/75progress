//
//  AppError.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import Foundation

enum AppError: LocalizedError, Equatable {
    case networkError(String)
    case authenticationError(String)
    case validationError(String)
    case persistenceError(String)
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "Network Error: \(message)"
        case .authenticationError(let message):
            return "Authentication Error: \(message)"
        case .validationError(let message):
            return "Validation Error: \(message)"
        case .persistenceError(let message):
            return "Data Error: \(message)"
        case .unknown(let message):
            return "Unknown Error: \(message)"
        }
    }
    
    var userFriendlyMessage: String {
        switch self {
        case .networkError:
            return "Please check your internet connection and try again."
        case .authenticationError:
            return "There was an issue signing you in. Please try again."
        case .validationError(let message):
            return message
        case .persistenceError:
            return "There was an issue saving your data. Please try again."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
