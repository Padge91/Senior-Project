//
//  CommentsDataSource.swift
//  Embr
//
//  Created by Alex Ronquillo on 10/5/15.
//  Copyright © 2015 SeniorProject. All rights reserved.
//

import Foundation

public class CommentsDataSource {
    
    static func insertComment(parentType: CommentParentType, parentId: Int, body: String) {
        EmbrConnection.put("/cgi-bin/AddComment.py", httpBody:
            "parent_type=\(parentType.value())&" +
            "parent_id=\(parentId)&" +
            "session=\(SessionModel.getSession())&" +
            "content=\(body)"
            , completionHandler: {data, response, error in print(NSString(data: data!, encoding: NSUTF8StringEncoding))})
    }
}

enum CommentParentType {
    case Item
    case Comment
    
    func value() -> String {
        switch (self) {
        case Item:
            return "item"
        case Comment:
            return "comment"
        }
    }
}