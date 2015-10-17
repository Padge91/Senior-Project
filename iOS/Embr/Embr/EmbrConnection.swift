//
//  EmbrConnection.swift
//  Embr
//
//  Created by Alex Ronquillo on 10/11/15.
//  Copyright © 2015 SeniorProject. All rights reserved.
//

import Foundation

class EmbrConnection {
    static func get(path: String, params: [String: String]?, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        let urlComponents = buildURLComponents(path)
        var queryItems = [NSURLQueryItem]()
        if params != nil {
            for parameter in params! {
                queryItems.append(NSURLQueryItem(name: parameter.0, value: parameter.1))
            }
            urlComponents.queryItems = queryItems
        }
        let getRequest = NSURLRequest(URL: urlComponents.URL!)
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(getRequest, completionHandler: completionHandler)
        dataTask.resume()
    }
    
    static func post(path: String, httpBody: String, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        postOrPut("POST", path: path, httpBody: httpBody, completionHandler: completionHandler)
    }
    
    static func put(path: String, httpBody: String, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        postOrPut("PUT", path: path, httpBody: httpBody, completionHandler: completionHandler)
    }
    
    private static func postOrPut(httpMethod: String, path: String, httpBody: String,
        completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
            let urlComponents = buildURLComponents(path)
            let request = NSMutableURLRequest(URL: urlComponents.URL!)
            request.HTTPMethod = httpMethod
            request.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            print("\(NSString(data: request.HTTPBody!, encoding: NSUTF8StringEncoding))")
            let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: completionHandler)
            dataTask.resume()
    }
    
    private static func buildURLComponents(path: String) -> NSURLComponents {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "52.88.5.108"
        urlComponents.path = path
        return urlComponents
    }
}