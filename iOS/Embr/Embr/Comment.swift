import Foundation

class Comment {
    private(set) var id: Int
    private(set) var author: User
    private(set) var body: String
    private(set) var flagged: Bool
    private(set) var parent: Comment?
    private(set) var rating: Int?
    private(set) var children: [Comment]
    
    init(id: Int, userWhoWroteTheComment author: User, body: String, isFlaggedAsInappropriate flagged: Bool = false, parentComment parent: Comment?, rating: Int? = nil, children: [Comment] = [Comment]()) {
        self.id = id
        self.author = author
        self.body = body
        self.flagged = flagged
        self.parent = parent
        self.rating = rating
        self.children = children
    }
    
    func addChild(newComment: Comment) {
        children.append(newComment)
    }
    
    func toString() -> String {
        if parent != nil {
            let parentComment = "\(parent!.author.username) said: \(parent!.body.substringToIndex(parent!.body.startIndex.advancedBy(20)))..."
            return "\(parentComment)\n\n\(body)\n-\(author.username)"
        } else {
            return "\(body)\n-\(author.username)"
        }
    }
    
    static func parseJsonComments(commentsOnItem commentArray: NSArray, parentComment parent: Comment?) -> [Comment] {
        var comments = [Comment]()
        for element in commentArray {
            if let commentInfo = element as? NSDictionary {
                // Parse comment information
                let parentComment = parent
                let id = commentInfo["id"] as! Int
                let content = commentInfo["content"] as! String
                let rating = commentInfo["user_review"] as? Int
                
                // Parse author information
                let userId = commentInfo["user_id"] as! Int
                let username = commentInfo["user_name"] as! String
                let author = User(id: userId, username: username, parentalControls: nil)
                
                // Create comment
                let comment = Comment(id: id, userWhoWroteTheComment: author, body: content, isFlaggedAsInappropriate: false, parentComment: parent, rating: rating, children: [])
                
                // Parse child comments
                if let childComments = commentInfo["child_comments"] as? NSArray {
                    let children = parseJsonComments(commentsOnItem: childComments, parentComment: parentComment)
                    for child in children {
                        comment.addChild(child)
                    }
                }
                comments.append(comment)
            }
        }
        return comments
    }
}