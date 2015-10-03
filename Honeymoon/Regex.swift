//
//  Regex.swift
//  Honeymoon
//
//  Created by skyline on 15/9/29.
//  Copyright © 2015年 skyline. All rights reserved.
//

import Foundation

import Foundation

extension String {
    var length : Int {
        return self.characters.count
    }
    
    func repeatString(n:Int) -> String {
        var result = self
        for _ in 1 ..< n {
            result.appendContentsOf(self)
        }
        return result
    }
    
    private var WHITESPACE_REGEXP: String {
        return "[\t\n\r\u{11}\u{12} ]"
    }
    
    func lstrip(s:String) -> String {
        let re = try! NSRegularExpression(pattern: s, options: NSRegularExpressionOptions.CaseInsensitive)
        return re.stringByReplacingMatchesInString(self, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, self.length), withTemplate: "")
    }
    
    func lstrip() -> String {
        return self.lstrip("^\(self.WHITESPACE_REGEXP)+")
    }
    
    func rstrip(s:String) -> String {
        let re = try! NSRegularExpression(pattern: s, options: NSRegularExpressionOptions.CaseInsensitive)
        return re.stringByReplacingMatchesInString(self, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, self.length), withTemplate: "")
    }
    
    func rstrip() -> String {
        return self.rstrip("\(self.WHITESPACE_REGEXP)+$")
    }
}

public class Regex : Hashable, Equatable{
    private var re:NSRegularExpression?
    var pattern:String
    var matches:RegexMatch?
    public var hashValue: Int {
        get {
            return self.pattern.hash
        }
    }
    
    init(pattern:String, options: NSRegularExpressionOptions=NSRegularExpressionOptions.CaseInsensitive) {
        self.pattern = pattern
        self.re = try? NSRegularExpression(pattern: self.pattern, options: options)
        
    }
    
    func match(str:String, pos:Int=0) -> RegexMatch? {
        if let re = self.re {
            self.matches = RegexMatch(str:str, matches: re.matchesInString(str, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(pos, str.length)))
            if self.matches?.matchCount > 0 {
                return self.matches
            }
            else {
                return nil
            }
        }
        return nil
    }
}

public func == (lhs: Regex, rhs: Regex) -> Bool {
    return lhs.pattern == rhs.pattern
}


public class RegexMatch  {
    private var _m:[AnyObject]?
    var matchedString = [String]()
    var _str:String // String to match against
    var matchCount:Int = 0
    var rangeCount = [Int]()
    var start:[String.Index] = []
    var end:[String.Index] = []
    
    init(str:String, matches:[AnyObject]?) {
        _str = str
        if let _matches = matches {
            _m = _matches
            matchCount = _matches.count
            let matches = _m as! [NSTextCheckingResult]
            for match in matches  {
                var rc = match.numberOfRanges
                for i in 0..<match.numberOfRanges {
                    let range = match.rangeAtIndex(i)
                    if range.location > _str.characters.count {
                        rc -= 1
                        continue;
                    }
                    start.append(_str.startIndex.advancedBy(range.location))
                    end.append(start.last!.advancedBy(range.length))
                    let r = _str.substringWithRange(Range<String.Index>(start: start.last!, end: end.last!))
                    matchedString.append(r)
                }
                rangeCount.append(rc)
            }
        }
        _str = self.group(0)
    }
    
    func range() -> Range<String.Index> {
        return Range<String.Index>(start: self.start[0], end: self.end[0])
    }
    
    func range(index:Int) -> Range<String.Index> {
        return Range<String.Index>(start: self.start[index], end: self.end[index])
    }
    
    func endIndex(index:Int) -> String.Index {
        return self.end[index]
    }
    
    func group(index:Int) -> String {
        // Index out of bound
        if index >= matchedString.count {
            return ""
        }
        return matchedString[index]
    }
}