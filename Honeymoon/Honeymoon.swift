//
//  Honeymoon.swift
//  Honeymoon
//
//  Created by skyline on 15/9/29.
//  Copyright © 2015年 skyline. All rights reserved.
//

import Foundation
import Mustache


public class Honeymoon {
    private let server = Server()
    public var templateBundle: NSBundle?
    private var _staticPath: String?
    public var staticURLFilter: FilterFunction?
    public var staticPath: String? {
        set {
            _staticPath = newValue
            if let dir = newValue {
                self.addStaticHandler(dir)
                self.staticURLFilter = Filter{ (x: String?) in
                    return Box("\(self.server.url)static/")
                }
            }
        }
        get {
            return _staticPath
        }
    }
    
    public func get(route:String, handlerClosure:HandlerClosure) {
        self.route(route, method: "GET", handlerClosure: handlerClosure)
    }
    
    public func post(route:String, handlerClosure:HandlerClosure) {
        self.route(route, method: "POST", handlerClosure: handlerClosure)
    }
    
    public func route(route:String, method:String, handlerClosure: HandlerClosure) {
        self.server.addRoute(route, method: method, handlerClosure: handlerClosure)
    }
    
    public func addStaticHandler(dir:String) {
        self.server.addStaticHandler("/static/", dir: dir)
    }
    
    public func renderTemplate(templateName:String, data:[String:AnyObject]?=nil, bundle:NSBundle?=nil) -> String {
        let b = bundle ?? self.templateBundle
        if let template = try? Template(named: templateName, bundle: b, templateExtension: "mustache", encoding: NSUTF8StringEncoding) {
            if let s = self.staticURLFilter {
                template.registerInBaseContext("staticURL", Box(s))
            }
            if let r = try? template.render(Box(data)) {
                return r
            }
        }
        return ""
    }
    
    public func start(port:UInt?=nil) {
        self.server.start(port)
    }
}