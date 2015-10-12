//
//  EmbrConnection.swift
//  Embr
//
//  Created by Alex Ronquillo on 10/11/15.
//  Copyright © 2015 SeniorProject. All rights reserved.
//

import Foundation

class EmbrConnection {
    static let host = "52.88.5.108"
    
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
    
    static func post(path: String, httpBody: [String: String]?, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        let urlComponents = buildURLComponents(path)
        let postRequest = NSMutableURLRequest(URL: urlComponents.URL!)
        postRequest.HTTPMethod = "POST"
        postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if httpBody != nil {
            if let data = makeDataFromBody(httpBody!) {
                postRequest.HTTPBody = data
            }
        }
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(postRequest, completionHandler: completionHandler)
        dataTask.resume()
    }
    
    private static func makeDataFromBody(body: [String: String]) -> NSData? {
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
            return data
        } catch {
            print("Invalid data")
        }
        return nil
    }
    
    private static func buildURLComponents(path: String) -> NSURLComponents {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = self.host
        urlComponents.path = path
        return urlComponents
    }
}