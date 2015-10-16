//
//  SessionModel.swift
//  Embr
//
//  Created by Alex Ronquillo on 10/14/15.
//  Copyright © 2015 SeniorProject. All rights reserved.
//

import Foundation


class SessionModel {
    private static let userDefaultSessionKey = "sessionid"

    static func storeSession(sessionId session: String) {
        NSUserDefaults.standardUserDefaults().setObject(session, forKey: userDefaultSessionKey)
    }

    static func removeSession() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(userDefaultSessionKey)
    }
    
    private static func sessionIsValid(sessionId: String) -> Bool {
        // TODO: ask server
        return true
    }

    static func getSession() -> String {
        if let session = NSUserDefaults.standardUserDefaults().objectForKey(userDefaultSessionKey) as? String {
            if sessionIsValid(session) {
                print(session)
                return session
            }
        }
        return ""
    }
}