//
//  SYPlanTests.swift
//  SYPlanTests
//
//  Created by Ray on 2019/7/4.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import XCTest

class SYPlanTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testRegex() {
        // 驗證手機格式
        XCTAssert("0976346095".isValidPhone, "該號碼符合手機格式")
        XCTAssert("886976346095".isValidPhone, "該號碼符合手機格式")
        XCTAssert("+886976346095".isValidPhone, "該號碼符合手機格式")
        XCTAssert("+8869763460951111".isValidPhone, "該號碼符合手機格式")
    }

}
