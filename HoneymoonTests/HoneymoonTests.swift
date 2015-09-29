//
//  HoneymoonTests.swift
//  HoneymoonTests
//
//  Created by skyline on 15/9/29.
//  Copyright © 2015年 skyline. All rights reserved.
//

import XCTest
@testable import Honeymoon

class HoneymoonTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let app = Honeymoon()
        
        app.templateBundle = bundle
        app.staticPath = bundle.resourcePath
        
        app.get("/hello") { req in
            return "Hello"
        }
        
        app.get("/list/:userId/:userName") { req in
            return "list"
        }
        
        app.get("/test") { req in
            return app.renderTemplate("Test", data: ["name": "Chester","value": 10000, "taxed_value": 10000 - (10000 * 0.4), "in_ca": true])
        }
        
        app.start()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
