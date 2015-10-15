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

    static func getSession() -> String {
        let session = NSUserDefaults.standardUserDefaults().objectForKey(userDefaultSessionKey)
        return session as? String ?? ""
    }
}