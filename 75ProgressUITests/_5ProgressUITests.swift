//
//  _5ProgressUITests.swift
//  75ProgressUITests
//
//  Created by Happiness Adeboye on 2/8/2025.
//

import XCTest

final class _5ProgressUITests: XCTestCase {

    override func setUpWithError() throws {

        continueAfterFailure = false


    }

    override func tearDownWithError() throws {
    }

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

   
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
