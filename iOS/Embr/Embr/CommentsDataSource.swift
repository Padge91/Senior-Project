//
//  CommentsDataSource.swift
//  Embr
//
//  Created by Alex Ronquillo on 10/5/15.
//  Copyright © 2015 SeniorProject. All rights reserved.
//

import Foundation

public class CommentsDataSource {
    private static var instance: CommentsDataSource?;
    
    static func getInstance() -> CommentsDataSource {
        if instance == nil {
            instance = CommentsDataSource()
        }
        return instance!
    }
    
    func insertComment(subject: String, body: String) {
        // Insert comment into the database
    }
}