//
//  OnboardingViewModelTests.swift
//  75ProgressTests
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import XCTest
@testable import _5Progress

class OnboardingViewModelTests: XCTestCase {
    var viewModel: OnboardingViewModel!
    var coordinator: OnboardingCoordinator!
    
    override func setUp() {
        super.setUp()
        coordinator = OnboardingCoordinator()
        viewModel = OnboardingViewModel(coordinator: coordinator)
    }
    
    override func tearDown() {
        viewModel = nil
        coordinator = nil
        super.tearDown()
    }
    
    // MARK: - Name Validation Tests
    
    func testValidNames() {
        let validNames = [
            "John",
            "Jane Doe",
            "Mary Jane Watson",
            "A",
            "This is a very long name that is exactly twenty four characters long",
            "José María",
            "Jean-Pierre"
        ]
        
        for name in validNames {
            XCTAssertTrue(viewModel.validateName(name), "Name '\(name)' should be valid")
        }
    }
    
    func testInvalidNames() {
        let invalidNames = [
            "", // Empty
            " ", // Only space
            "A", // Too short (less than 2 characters)
            "This is a very long name that exceeds twenty four characters", // Too long
            "John123", // Contains numbers
            "John@Doe", // Contains special characters
            "John_Doe", // Contains underscore
            "John-Doe", // Contains hyphen
            "John.Doe", // Contains period
            "John\nDoe", // Contains newline
            "John\tDoe" // Contains tab
        ]
        
        for name in invalidNames {
            XCTAssertFalse(viewModel.validateName(name), "Name '\(name)' should be invalid")
        }
    }
    
    func testValidEmails() {
        let validEmails = [
            "test@example.com",
            "user.name@domain.co.uk",
            "user+tag@example.org",
            "user123@test-domain.com",
            "a@b.co"
        ]
        
        for email in validEmails {
            XCTAssertTrue(viewModel.validateEmail(email), "Email '\(email)' should be valid")
        }
    }
    
    func testInvalidEmails() {
        let invalidEmails = [
            "", // Empty
            " ", // Only space
            "invalid-email", // No @
            "@example.com", // No local part
            "user@", // No domain
            "user@.com", // Invalid domain
            "user..name@example.com", // Double dots
            "user@example..com", // Double dots in domain
            "user name@example.com", // Space in local part
            "user@exam ple.com" // Space in domain
        ]
        
        for email in invalidEmails {
            XCTAssertFalse(viewModel.validateEmail(email), "Email '\(email)' should be invalid")
        }
    }
    
    func testNameValidationWithWhitespace() {
        // Test trimming behavior
        XCTAssertTrue(viewModel.validateName("  John  "), "Name with leading/trailing spaces should be valid")
        XCTAssertTrue(viewModel.validateName("John Doe"), "Name with internal spaces should be valid")
        XCTAssertFalse(viewModel.validateName("  "), "Name with only spaces should be invalid")
    }
    
    // MARK: - Goal Selection Tests
    
    func testGoalSelection() {
        let goalId = "weight_loss"
        
        // Initially no goals selected
        XCTAssertFalse(viewModel.isGoalSelected(goalId))
        XCTAssertFalse(viewModel.state.canProceedFromGoals)
        
        // Select a goal
        viewModel.toggleGoal(goalId)
        XCTAssertTrue(viewModel.isGoalSelected(goalId))
        XCTAssertTrue(viewModel.state.canProceedFromGoals)
        
        // Deselect the goal
        viewModel.toggleGoal(goalId)
        XCTAssertFalse(viewModel.isGoalSelected(goalId))
        XCTAssertFalse(viewModel.state.canProceedFromGoals)
    }
    
    func testMultipleGoalSelection() {
        let goalIds = ["weight_loss", "muscle_gain", "fitness"]
        
        // Select multiple goals
        for goalId in goalIds {
            viewModel.toggleGoal(goalId)
            XCTAssertTrue(viewModel.isGoalSelected(goalId))
        }
        
        XCTAssertTrue(viewModel.state.canProceedFromGoals)
        XCTAssertEqual(viewModel.state.selectedGoals.count, 3)
        
        // Deselect one goal
        viewModel.toggleGoal(goalIds[0])
        XCTAssertFalse(viewModel.isGoalSelected(goalIds[0]))
        XCTAssertTrue(viewModel.isGoalSelected(goalIds[1]))
        XCTAssertTrue(viewModel.isGoalSelected(goalIds[2]))
        XCTAssertTrue(viewModel.state.canProceedFromGoals)
    }
    
    // MARK: - Navigation Tests
    
    func testNavigationConstraints() {
        // Test goal page navigation
        viewModel.state.currentPage = 5 // Goal selection page
        XCTAssertFalse(viewModel.canProceed, "Should not be able to proceed without selecting goals")
        
        viewModel.toggleGoal("weight_loss")
        XCTAssertTrue(viewModel.canProceed, "Should be able to proceed after selecting a goal")
        
        // Test name page navigation
        viewModel.state.currentPage = 6 // Name input page
        viewModel.state.displayName = "J" // Invalid name
        viewModel.state.email = "invalid-email" // Invalid email
        XCTAssertFalse(viewModel.canProceed, "Should not be able to proceed with invalid name and email")
        
        viewModel.state.displayName = "John"
        viewModel.state.email = "john@example.com"
        XCTAssertTrue(viewModel.canProceed, "Should be able to proceed with valid name and email")
    }
    
    func testPageNavigation() {
        let initialPage = viewModel.state.currentPage
        
        // Test next page
        viewModel.nextPage()
        XCTAssertEqual(viewModel.state.currentPage, initialPage + 1)
        
        // Test previous page
        viewModel.previousPage()
        XCTAssertEqual(viewModel.state.currentPage, initialPage)
        
        // Test previous page at beginning
        viewModel.previousPage()
        XCTAssertEqual(viewModel.state.currentPage, 0, "Should not go below page 0")
    }
    
    // MARK: - State Management Tests
    
    func testDisplayNameUpdate() {
        let testName = "John Doe"
        viewModel.updateDisplayName(testName)
        XCTAssertEqual(viewModel.state.displayName, testName)
    }
    
    func testEmailUpdate() {
        let testEmail = "john@example.com"
        viewModel.updateEmail(testEmail)
        XCTAssertEqual(viewModel.state.email, testEmail)
    }
    
    func testOnboardingStateInitialization() {
        XCTAssertEqual(viewModel.state.currentPage, 0)
        XCTAssertTrue(viewModel.state.selectedGoals.isEmpty)
        XCTAssertEqual(viewModel.state.displayName, "")
        XCTAssertFalse(viewModel.state.hasCompletedOnboarding)
    }
}
