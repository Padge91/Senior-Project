import Foundation

class SessionModel {
    private static let userDefaultSessionKey = "sessionid"
    static let noSession = "no session"

    static func storeSession(sessionId session: String) {
        NSUserDefaults.standardUserDefaults().setObject(session, forKey: userDefaultSessionKey)
    }

    static func removeSession() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(userDefaultSessionKey)
    }
    
    static func validateSession(sessionId: String, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.get("/cgi-bin/VerifySession.py", params: ["session": sessionId], completionHandler: completionHandler)
    }

    static func getSession() -> String {
        let session = NSUserDefaults.standardUserDefaults().objectForKey(userDefaultSessionKey) as? String
        return session ?? noSession
    }
}