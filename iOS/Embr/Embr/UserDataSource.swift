//
//  UserDataSource.swift
//  Embr
//
//  Created by Alex Ronquillo on 10/5/15.
//  Copyright © 2015 SeniorProject. All rights reserved.
//

import Foundation

class UserDataSource {
    
    static func attemptLogin(username: String, password: String, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.get("/cgi-bin/Login.py", params: ["username": username, "password": password], completionHandler: completionHandler)
    }
    
    static func getUserId(completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.get("/cgi-bin/GetUserIdFromSession.py", params: ["session": SessionModel.getSession()], completionHandler: completionHandler)
    }
    
    static func signUp(username: String, email: String, password: String, confirmPassword: String, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.post("/cgi-bin/CreateAccount.py", httpBody: ["username": username, "email": email, "password": password, "passwordConfirm": confirmPassword], completionHandler: completionHandler)
    }
}