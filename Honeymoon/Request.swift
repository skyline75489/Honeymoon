//
//  Request.swift
//  Honeymoon
//
//  Created by skyline on 15/9/29.
//  Copyright © 2015年 skyline. All rights reserved.
//

import Foundation

public class Request {
    public var method:String?
    public var url:String?
    public var headers:Dictionary<String,String>?
    public var path:String?
    public var query:Dictionary<String,String>?
    public var params:[String:String]?
}