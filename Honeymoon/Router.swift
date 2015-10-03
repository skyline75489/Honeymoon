//
//  Router.swift
//  Honeymoon
//
//  Created by skyline on 15/9/29.
//  Copyright © 2015年 skyline. All rights reserved.
//

import Foundation

public typealias HandlerClosure = (Request) -> AnyObject

let VALID_METHODS = ["HEAD", "GET", "POST", "DELETE", "PUT"]

let RULE_PATTERN = Regex(pattern: "([^<]*)<(?:([a-zA-Z_][a-zA-Z0-9_]*):)?([a-zA-Z_][a-zA-Z0-9_]*)>")


func parseRule(var rule:String) -> [(_type:String, _variable:String, _static:String)] {
    var result = [(_type:String, _variable:String, _static:String)]()
    while rule.length > 0 {
        let m = RULE_PATTERN.match(rule)
        if let m = m {
            if m.rangeCount[0] == 0 {
                break;
            }
            if m.rangeCount[0] == 3 {
                result.append(("", "", m.group(1)))
                result.append(("", m.group(2), ""))
                rule = rule.substringFromIndex(m.endIndex(0))
            }
            if m.rangeCount[0] == 4 {
                result.append(("", "", m.group(1)))
                result.append((m.group(2), m.group(3), ""))
                rule = rule.substringFromIndex(m.endIndex(0))
            }
        }
        else {
            result.append(("", "", rule))
            break
        }

    }
    return result
}

public class Handler {
    
    public var path:String?
    public var method:String?
    public var handlerClosure:HandlerClosure?
    public var pathRegex:String?
    public var routeParameters:[String]?
    
    init(path:String, method:String, handlerClosure:HandlerClosure, pathRegex:String?=nil, parameters:[String]?=nil) {
        self.path = path
        self.handlerClosure = handlerClosure
        self.method = method
        self.pathRegex = pathRegex
        self.routeParameters = parameters
    }
}

public class Rule {
    public var rule:String?
    public var methods=[String]()
    public var _regex:Regex?
    public var _trace:[(Bool, String)]?
    public var variables = [String]()
    
    init(rule:String, method:String) {
        self.rule = rule
        self.methods.append(method)
        self.buildRegex()
    }
    public func buildRegex() {
        var regexParts = [String]()
        for (_type, _variable, _static) in parseRule(self.rule!) {
            if _type.length == 0 && _static.length > 0 {
                regexParts.append(_static)
            } else if _variable.length > 0 {
                regexParts.append(String(format: "(%@)", arguments: ["[a-zA-Z0-9_]*"]))
                self.variables.append(_variable)
            }
        }
        let regexString = String(format: "^%@$", arguments: [regexParts.joinWithSeparator("")])
        self._regex = Regex(pattern: regexString)
    }
}


public func ==(lhs: Rule, rhs: Rule) -> Bool {
    return lhs._regex == rhs._regex
}


extension Rule : Hashable {
    public var hashValue: Int {
        get {
            return self._regex!.hashValue
        }
    }
}

