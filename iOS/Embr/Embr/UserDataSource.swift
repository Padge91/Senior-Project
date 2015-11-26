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
    
    static func getUser(id: Int, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.get("/cgi-bin/GetUserInfo.py", params: ["user_id": "\(id)"], completionHandler: completionHandler)
    }

    static func addFriend(friend: Int, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.put("/cgi-bin/AddFriend.py", httpBody:
            "session=\(SessionModel.getSession())&" +
            "user_id=\(friend)", completionHandler: completionHandler)
    }
    
    static func getFriendsList(user: Int, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.get("/cgi-bin/GetFriendsList.py", params: ["session": SessionModel.getSession(), "user_id": "\(user)"], completionHandler: completionHandler)
    }
    
    static func removeFriend (user: Int, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.put("/cgi-bin/RemoveFriend.py", httpBody:
            "session=\(SessionModel.getSession())&" +
            "user_id=\(user)", completionHandler: completionHandler)
    }
    
    static func signUp(username: String, email: String, password: String, confirmPassword: String, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.post("/cgi-bin/CreateAccount.py", httpBody:
            "username=\(username)&" +
            "email=\(email)&" +
            "password=\(password)&" +
            "passwordConfirm=\(confirmPassword)", completionHandler: completionHandler)
    }
    
    static func getUpdates(completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.get("/cgi-bin/GetUpdatesFeed.py", params: ["session": SessionModel.getSession()], completionHandler: completionHandler)
    }
}