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
    var handlerMap = [Rule:Handler]()
    
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
        webServer.addDefaultHandlerForMethod("POST", requestClass: GCDWebServerRequest.self, processBlock: {request in
            let errorResp =  GCDWebServerDataResponse(HTML: "<html><body><h3>Not Found</h3></body></html>")
            errorResp.statusCode = 404
            return errorResp
        })
    }
    
    public func addRoute(route:String, method: String, requestClass: AnyClass=GCDWebServerRequest.self, handlerClosure: HandlerClosure) {
        let r = Rule(rule: route, method: method)
        if r.variables.count > 0 {
            let h = Handler(path: route, method: method, handlerClosure: handlerClosure, pathRegex: r._regex?.pattern, parameters: r.variables)
            self.addHandlerWithParameter(h, requestClass: requestClass)
        } else {
            let h = Handler(path: route, method: method, handlerClosure: handlerClosure)
            self.addHandler(h, requestClass: requestClass)
        }
    }
    
    public func addStaticHandler(basePath:String, dir:String) {
        self.webServer.addGETHandlerForBasePath(basePath, directoryPath: dir, indexFilename: nil, cacheAge: 3600, allowRangeRequests: false)
    }
    
    private func addHandler(handler:Handler, requestClass:AnyClass=GCDWebServerRequest.self) {
        webServer.addHandlerForMethod(handler.method, path: handler.path, requestClass: requestClass, processBlock: { request in
            
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
    
    private func addHandlerWithParameter(handler: Handler, requestClass:AnyClass=GCDWebServerRequest.self) {
        webServer.addHandlerForMethod(handler.method, pathRegex: handler.pathRegex, requestClass: requestClass, processBlock: { request in
            
            let r = Regex(pattern: handler.pathRegex!)
            var params = [String:String]()
            if let m = r.match(request.path) {
                for var i = 0 ; i < handler.routeParameters?.count; i++ {
                    let key = handler.routeParameters?[i]
                    params[key!] = m.group(i+1)
                }
            }
            
            let req = self.prepareRequest(request, routeParams:params)
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
    
    private func prepareRequest(request:GCDWebServerRequest, routeParams:[String:String]?=nil) -> Request {
        let req = Request()
        req.method = request.method
        req.path = request.path
        req.params = routeParams
        if let r = request as? GCDWebServerURLEncodedFormRequest {
            req.form = [String:String]()
            for (k, v) in r.arguments {
                let newKey = String(k)
                let newValue = v as! String
                req.form?[newKey] = newValue
            }
        }
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