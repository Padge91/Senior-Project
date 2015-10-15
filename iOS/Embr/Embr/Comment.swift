import Foundation

class Comment {
    private(set) var id: String
    private(set) var author: User
    private(set) var body: String
    private(set) var flagged: Bool
    private(set) var parent: Comment?
    private(set) var rating: Int
    private(set) var children: [Comment]
    
    init(id: String, userWhoWroteTheComment author: User, body: String, isFlaggedAsInappropriate flagged: Bool = false, parentComment parent: Comment?, rating: Int = 0, children: [Comment] = [Comment]()) {
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
}