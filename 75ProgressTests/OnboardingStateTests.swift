//
//  OnboardingStateTests.swift
//  75ProgressTests
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import XCTest
@testable import _5Progress

class OnboardingStateTests: XCTestCase {
    
    // MARK: - Goal Selection Tests
    
    func testCanProceedFromGoals() {
        var state = OnboardingState()
        
        // Initially no goals selected
        XCTAssertFalse(state.canProceedFromGoals)
        
        // Add one goal
        state.selectedGoals.insert("weight_loss")
        XCTAssertTrue(state.canProceedFromGoals)
        
        // Add multiple goals
        state.selectedGoals.insert("muscle_gain")
        XCTAssertTrue(state.canProceedFromGoals)
        
        // Remove all goals
        state.selectedGoals.removeAll()
        XCTAssertFalse(state.canProceedFromGoals)
    }
    
    // MARK: - Name Validation Tests
    
    func testCanFinishWithValidNamesAndEmails() {
        var state = OnboardingState()
        
        let validNames = [
            "John",
            "Jane Doe",
            "Mary Jane Watson",
            "This is a very long name that is exactly twenty four characters long"
        ]
        
        let validEmails = [
            "test@example.com",
            "user.name@domain.co.uk",
            "user+tag@example.org"
        ]
        
        for name in validNames {
            for email in validEmails {
                state.displayName = name
                state.email = email
                XCTAssertTrue(state.canFinish, "Name '\(name)' and email '\(email)' should allow finishing")
            }
        }
    }
    
    func testCannotFinishWithInvalidNames() {
        var state = OnboardingState()
        state.email = "valid@example.com" // Set valid email
        
        let invalidNames = [
            "", // Empty
            " ", // Only space
            "A", // Too short
            "This is a very long name that exceeds twenty four characters", // Too long
            "John123", // Contains numbers
            "John@Doe", // Contains special characters
            "John_Doe" // Contains underscore
        ]
        
        for name in invalidNames {
            state.displayName = name
            XCTAssertFalse(state.canFinish, "Name '\(name)' should not allow finishing")
        }
    }
    
    func testCannotFinishWithInvalidEmails() {
        var state = OnboardingState()
        state.displayName = "John Doe" // Set valid name
        
        let invalidEmails = [
            "", // Empty
            " ", // Only space
            "invalid-email", // No @
            "@example.com", // No local part
            "user@", // No domain
            "user@.com" // Invalid domain
        ]
        
        for email in invalidEmails {
            state.email = email
            XCTAssertFalse(state.canFinish, "Email '\(email)' should not allow finishing")
        }
    }
    
    // MARK: - State Initialization Tests
    
    func testInitialState() {
        let state = OnboardingState()
        
        XCTAssertEqual(state.currentPage, 0)
        XCTAssertTrue(state.selectedGoals.isEmpty)
        XCTAssertEqual(state.displayName, "")
        XCTAssertEqual(state.email, "")
        XCTAssertFalse(state.hasCompletedOnboarding)
        XCTAssertFalse(state.canProceedFromGoals)
        XCTAssertFalse(state.canFinish)
    }
    
    // MARK: - Codable Tests
    
    func testStateCodable() {
        var originalState = OnboardingState()
        originalState.currentPage = 3
        originalState.selectedGoals = ["weight_loss", "muscle_gain"]
        originalState.displayName = "John Doe"
        originalState.email = "john@example.com"
        originalState.hasCompletedOnboarding = true
        
        // Encode
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(originalState) else {
            XCTFail("Failed to encode OnboardingState")
            return
        }
        
        // Decode
        let decoder = JSONDecoder()
        guard let decodedState = try? decoder.decode(OnboardingState.self, from: data) else {
            XCTFail("Failed to decode OnboardingState")
            return
        }
        
        // Verify
        XCTAssertEqual(decodedState.currentPage, originalState.currentPage)
        XCTAssertEqual(decodedState.selectedGoals, originalState.selectedGoals)
        XCTAssertEqual(decodedState.displayName, originalState.displayName)
        XCTAssertEqual(decodedState.email, originalState.email)
        XCTAssertEqual(decodedState.hasCompletedOnboarding, originalState.hasCompletedOnboarding)
    }
}
