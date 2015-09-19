//
//  Comment.swift
//  Embr
//
//  Created by Alex Ronquillo on 9/17/15.
//  Copyright © 2015 SeniorProject. All rights reserved.
//

import Foundation

class Comment {
    private(set) var id: String
    private(set) var author: User
    private(set) var subject: String
    private(set) var body: String
    private(set) var flagged: Bool
    private(set) var parent: Comment?
    private(set) var rating: Int
    
    init(id: String, userWhoWroteTheComment author: User, subject: String, body: String, isFlaggedAsInappropriate flagged: Bool = false, parentComment parent: Comment?, rating: Int = 0) {
        self.id = id
        self.author = author
        self.subject = subject
        self.body = body
        self.flagged = flagged
        self.parent = parent
        self.rating = rating
    }
    
    func toString() -> String {
        if parent != nil {
            let parentComment = "\(parent!.author.username) said: \(parent!.body.substringToIndex(parent!.body.startIndex.advancedBy(20)))..."
            return "\(parentComment)\n\n\(subject)\n\(body)\n-\(author.username)"
        } else {
            return "\(subject)\n\(body)\n-\(author.username)"
        }
    }
}