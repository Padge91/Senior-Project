//
//  Library.swift
//  Embr
//
//  Created by Alex Ronquillo on 10/16/15.
//  Copyright © 2015 SeniorProject. All rights reserved.
//

import Foundation

class Library : AnyObject {
    private(set) var id: Int
    private(set) var ownerId: Int
    private(set) var name: String
    private(set) var items: [MediaItem]
    
    init(id: Int, ownerId: Int, name: String) {
        self.id = id
        self.ownerId = ownerId
        self.name = name
        self.items = []
    }
    
    func addItemToLibrary(mediaItem: MediaItem) {
        items.append(mediaItem)
    }
    
    func removeItemAtIndex(index: Int) {
        items.removeAtIndex(index)
    }
}

func parseLibraryList(librariesArray libArray: NSArray) -> [Library] {
    var librariesList = [Library]()
    for element in libArray {
        if let libraryInfo = element as? NSDictionary {
            let id = libraryInfo["id"] as! Int
            let name = libraryInfo["name"] as! String
            let ownerId = libraryInfo["user_id"] as! Int
            let library = Library(id: id, ownerId: ownerId, name: name)
            librariesList.append(library)
        }
    }
    return librariesList
}