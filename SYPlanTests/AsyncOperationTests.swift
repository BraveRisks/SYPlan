//
//  AsyncOperationTests.swift
//  SYPlanTests
//
//  Created by Ray on 2020/10/12.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import XCTest

/// Reference: https://www.swiftbysundell.com/articles/asyncawait-in-swift-unit-tests/
class AsyncOperationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformingOperation() {
        // Given
        let operation = AsyncOperation { "Hello world" }
        let expectation = self.expectation(description: #function)
        var result: String?
        
        // When
        operation.perform { (value) in
            result = value
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(result, "Hello world")
    }

}
