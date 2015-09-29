//
//  Router.swift
//  Honeymoon
//
//  Created by skyline on 15/9/29.
//  Copyright © 2015年 skyline. All rights reserved.
//

import Foundation

public typealias HandlerClosure = (Request) -> AnyObject

public class Handler {
    
    public var path:String?
    public var method:String?
    public var handlerClosure:HandlerClosure?
    public var pathRegex:String?
    
    init(path:String, method:String, handlerClosure:HandlerClosure, pathRegex:String?=nil) {
        self.path = path
        self.handlerClosure = handlerClosure
        self.method = method
        self.pathRegex = pathRegex
    }
}

