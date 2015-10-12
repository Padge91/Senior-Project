//
//  UserDataSource.swift
//  Embr
//
//  Created by Alex Ronquillo on 10/5/15.
//  Copyright © 2015 SeniorProject. All rights reserved.
//

import Foundation

class UserDataSource {
    private let userDefaultSessionKey = "sessionid"
    private static var instance: UserDataSource?;
    
    static func getInstance() -> UserDataSource {
        if instance == nil {
            instance = UserDataSource()
        }
        return instance!
    }
    
    func storeSession(sessionId session: String) {
        NSUserDefaults.standardUserDefaults().setObject(session, forKey: userDefaultSessionKey)
    }
    
    func removeSession() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(userDefaultSessionKey)
    }
    
    func getSession() -> String? {
        let session = NSUserDefaults.standardUserDefaults().objectForKey(userDefaultSessionKey)
        if let sessionId = session as? String {
            return sessionId
        }
        return nil
    }
    
    func attemptLogin(username: String, password: String, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.get("/cgi-bin/login.py", params: ["username": username, "password": password], completionHandler: completionHandler)
    }
}