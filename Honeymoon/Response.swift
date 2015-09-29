//
//  Response.swift
//  Honeymoon
//
//  Created by skyline on 15/9/29.
//  Copyright © 2015年 skyline. All rights reserved.
//

import Foundation

public class Response {
    public var body:String?
    public var contentType:String?
    public var contentLength:UInt?
    public var statusCode:Int?
    public var headers:Dictionary<String, String>?
    
    public init(body:String) {
        self.body = body
        self.contentType = "text/html"
        self.contentLength = UInt(body.characters.count)
        self.statusCode = 200
    }
}