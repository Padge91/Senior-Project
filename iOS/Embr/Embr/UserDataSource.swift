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
    
    func attemptLogin(username: String, password: String) -> String? {
        /*
            Attempts a login given a username and password
            Return value:
                if the login was successful, the method returns the session id
                otherwise, the method returns nil
        */
        print("Attempted login with \(username) and \(password)")
        return nil
    }
}