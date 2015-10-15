//
//  UserDataSource.swift
//  Embr
//
//  Created by Alex Ronquillo on 10/5/15.
//  Copyright © 2015 SeniorProject. All rights reserved.
//

import Foundation

class UserDataSource {    
    private static var instance: UserDataSource?;
    
    static func getInstance() -> UserDataSource {
        if instance == nil {
            instance = UserDataSource()
        }
        return instance!
    }
    
    func attemptLogin(username: String, password: String, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.get("/cgi-bin/Login.py", params: ["username": username, "password": password], completionHandler: completionHandler)
    }
    
    func getUserId(completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.get("/cgi-bin/GetUserIdFromSession.py", params: ["session": SessionModel.getSession()], completionHandler: completionHandler)
    }
}