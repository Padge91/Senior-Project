import Foundation

class ItemDataSource {
    
    private static var instance: ItemDataSource?
    
    static func getInstance() -> ItemDataSource {
        if instance == nil {
            instance = ItemDataSource()
        }
        return instance!
    }
    
    func getItemsBySearchCriteria(searchCriteria: String) -> [MediaItem] {
        let user1 = User(id: "\(rand)", username: "Alex", parentalControls: nil)
        
        let genericLikeComment = Comment(id: "\(rand)", userWhoWroteTheComment: user1, subject: "I <3 this book!", body: "Hey, I love this book! 👍. The book was long, but it was super interesting! I really loved the characters, the action, and the story.", isFlaggedAsInappropriate: false, parentComment: nil, rating: 0)
        
        let genericDislikeComment = Comment(id: "\(rand)", userWhoWroteTheComment: user1, subject: "Re: I <3 this book!", body: "I don't like this book. It was dull and boring. The story was too long.", isFlaggedAsInappropriate: false, parentComment: genericLikeComment, rating: 0)
        
        let genericLikeComment2 = Comment(id: "\(rand)", userWhoWroteTheComment: user1, subject: "I <3 this book also!", body: "Hey, I love this book too!! 👍. I agree with other comments on this page.", isFlaggedAsInappropriate: false, parentComment: nil, rating: 0)
        
        let genericDislikeComment2 = Comment(id: "\(rand)", userWhoWroteTheComment: user1, subject: "Re: I <3 this book also!", body: "I don't like this book. It was dull and boring. The story was too long.", isFlaggedAsInappropriate: false, parentComment: genericLikeComment2, rating: 0)
        
        let genericDislikeComment3 = Comment(id: "\(rand)", userWhoWroteTheComment: user1, subject: "Re: I <3 this book also!", body: "I think you both are crazy!.", isFlaggedAsInappropriate: false, parentComment: genericDislikeComment2, rating: 0)
        
        genericLikeComment.addChild(genericDislikeComment)
        genericLikeComment2.addChild(genericDislikeComment2)
        genericLikeComment2.addChild(genericDislikeComment3)
        
        let blurb1 = "Frodo Baggins knew the Ringwraiths were searching for him—and the Ring of Power he bore that would enable Sauron to destroy all that was good in Middle-earth. Now it was up to Frodo and his faithful servant Sam to carry the Ring to where it could be destroyed—in the very center of Sauron's dark kingdom."
        
        let mediaItem: MediaItem = Book(id: "\(rand)", title: "The Fellowship of the Ring", imageName: "FellowshipBookCover", blurb: blurb1, recommendedAgeForParentalControls: nil, currentUserReview: 5, avgFriendReview: nil, avgReview: 4.9, author: "J.R.R. Tolkien", pageCount: 500, publisher: "Houghton Mifflin", comments: [genericLikeComment])
        
        let mediaItem2: MediaItem = Movie(id: "\(rand)", title: "Harry Potter and the Philosopher's Stone", imageName: "PhilosophersStoneCover", blurb: "This is the first book in the Harry Potter series", recommendedAgeForParentalControls: nil, currentUserReview: 5, avgFriendReview: 4.5, avgReview: 4.5, director: "Chris Columbus", allActors: ["Daniel Radcliffe", "Emma Watson"], allCrewExceptDirector: ["Steven Kloves", "David Heyman"], comments: [genericLikeComment, genericLikeComment2])
        
        let mediaItems = [mediaItem, mediaItem2]
        
        var mediaItemsThatMeetTheSearchCriteria = [MediaItem]()
        for item in mediaItems {
            if item.title.lowercaseString.containsString(searchCriteria.lowercaseString) {
                mediaItemsThatMeetTheSearchCriteria.append(item)
            }
        }
        return mediaItemsThatMeetTheSearchCriteria
        
    }
    
    func updateItemReview(mediaItem: MediaItem, review: Int) {
        // access database
    }
    
}