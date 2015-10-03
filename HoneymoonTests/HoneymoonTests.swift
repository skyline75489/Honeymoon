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
        
        let app = Honeymoon()

        let bundle = NSBundle(forClass: self.dynamicType)
        
        app.templateBundle = bundle
        app.staticPath = bundle.resourcePath
        
        app.get("/") { req in
            return "Honeymoon stared."
        }
        
        app.get("/hello/<int:id>/story/<userId>") { req in
            let id = req.params!["id"]!
            let userId = req.params!["userId"]!
            return "Hello: \(id) \(userId)"
        }
        
        app.get("/list/<userId>") { req in
            let userId = req.params!["userId"]!
            return "list\(userId)"
        }
        
        app.get("/testTemplate") { req in
            return app.renderTemplate("Test", data: ["name": "Chester","value": 10000, "taxed_value": 10000 - (10000 * 0.4), "in_ca": true])
        }
        
        app.get("/testForm") { req in
            return app.renderTemplate("TestForm")
        }
        
        app.post("/post") { req in
            let c = req.form!["content"]!
            return "\(c)"
        }
        
        app.get("/testRedirect") { req in
            return app.redirect("/target")
        }
        
        app.get("/target") { req in
            return "Redirected."
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
