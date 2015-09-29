//
//  Server.swift
//  Honeymoon
//
//  Created by skyline on 15/9/29.
//  Copyright © 2015年 skyline. All rights reserved.
//

import Foundation
import GCDWebServer

public class Server {
    let webServer = GCDWebServer()
    var url:String {
        get {
            return self.webServer.serverURL.absoluteString
        }
    }
    
    init() {
        webServer.addDefaultHandlerForMethod("GET", requestClass: GCDWebServerRequest.self, processBlock: {request in
            let errorResp =  GCDWebServerDataResponse(HTML: "<html><body><h3>Not Found</h3></body></html>")
            errorResp.statusCode = 404
            return errorResp
        })
    }
    
    private func makeHandler(route: String, method:String, parameters:[String]?=nil, handlerClosure: HandlerClosure) -> Handler {
        let h = Handler(path: route, method:method, handlerClosure: handlerClosure)
        return h
    }
    
    public func addRoute(var route:String, method: String, handlerClosure: HandlerClosure) {
        var hasParameter = false
        if route.containsString(":") {
            hasParameter = true
        }
        var parameters = [String]()
        var urlRegexPattern = ""
        if hasParameter {
            while route.containsString(":") {
                let parameterIndex = route.rangeOfString(":")
                let l = route.substringFromIndex((parameterIndex?.startIndex)!)
                urlRegexPattern += "\(route.substringToIndex((parameterIndex?.startIndex)!))(.*)"
                let containsBackslash = l.rangeOfString("/") != nil
                var paraName = ""
                var end = Range(start: l.endIndex, end: l.endIndex)
                paraName = l.substringWithRange(Range(start: l.startIndex.advancedBy(1), end: end.endIndex))
                route = l.substringFromIndex(end.endIndex)
                if containsBackslash {
                    end = l.rangeOfString("/")!
                    paraName = l.substringWithRange(Range(start: l.startIndex.advancedBy(1), end: end.endIndex.predecessor()))
                    route = l.substringFromIndex(end.endIndex.predecessor())
                }
                parameters.append(paraName)
            }
        }
        let h = makeHandler(route, method: method, parameters: parameters, handlerClosure: handlerClosure)
        self.addHandler(h)
    }
    
    public func addStaticHandler(basePath:String, dir:String) {
        self.webServer.addGETHandlerForBasePath(basePath, directoryPath: dir, indexFilename: nil, cacheAge: 3600, allowRangeRequests: false)
    }
    
    private func addHandler(handler:Handler) {
        webServer.addHandlerForMethod(handler.method, path: handler.path, requestClass: GCDWebServerRequest.self, processBlock: { request in
            
            let req = self.prepareRequest(request)
            let resp = handler.handlerClosure!(req)
            
            var returnResp = Response(body: "")
            if let resp = resp as? Response {
                returnResp = resp
            }
            if let resp = resp as? String {
                returnResp = Response(body: resp)
            }
            return self.prepareResponse(returnResp)
        })
    }
    
    private func addHandlerWithParameter(handler: Handler) {
        
    }
    
    private func prepareRequest(request:GCDWebServerRequest) -> Request {
        let req = Request()
        req.method = request.method
        req.path = request.path
        
        return req
    }
    
    private func prepareResponse(response: Response) -> GCDWebServerResponse {
        let resp = GCDWebServerDataResponse.init(HTML: response.body)
        resp.statusCode = response.statusCode!
        resp.contentType = response.contentType
        resp.contentLength = response.contentLength!

        return resp
    }
    
    public func start(port:UInt?=nil) {
        if let port = port {
            webServer.runWithPort(port, bonjourName: "GCD Web Server")
        } else {
            webServer.runWithPort(8000, bonjourName: "GCD Web Server")
        }
    }
}