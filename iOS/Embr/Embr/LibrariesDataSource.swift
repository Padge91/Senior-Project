//
//  LibrariesDataSource.swift
//  Embr
//
//  Created by Alex Ronquillo on 10/15/15.
//  Copyright © 2015 SeniorProject. All rights reserved.
//

import Foundation

class LibrariesDataSource {
    static func getMyLibraries(userId: Int, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.get("/cgi-bin/GetLibrariesList.py", params: ["session": SessionModel.getSession(), "user_id": "\(userId)"], completionHandler: completionHandler)
    }
    
    static func getLibrary(libraryId: Int, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.get("/cgi-bin/GetLibraryItems.py", params: ["session": SessionModel.getSession(), "library_id": "\(libraryId)"], completionHandler: completionHandler)
    }
    
    static func addItemToLibrary(libraryId: Int, itemId: Int, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.put("/cgi-bin/AddItemToLibrary.py", httpBody:
            "session=\(SessionModel.getSession())&" +
            "library_id=\(libraryId)&" +
            "item_id=\(itemId)", completionHandler: completionHandler)
    }
}