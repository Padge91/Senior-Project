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
    
    static func createLibrary(library: String, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.put("/cgi-bin/CreateLibrary.py", httpBody:
            "session=\(SessionModel.getSession())&" +
            "library_name=\(library)&" +
            "visible=true", completionHandler: completionHandler)
    }
    
    static func deleteLibrary(libraryId: Int, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.put("/cgi-bin/DeleteLibrary.py", httpBody:
            "session=\(SessionModel.getSession())&" +
            "library_id=\(libraryId)"
            , completionHandler: completionHandler)
    }
    
    static func deleteItemFromLibrary(libraryId: Int, itemId: Int, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.put("/cgi-bin/RemoveItemFromLibrary.py", httpBody:
            "session=\(SessionModel.getSession())&" +
            "library_id=\(libraryId)&" +
            "item_id=\(itemId)", completionHandler: completionHandler)
    }
}