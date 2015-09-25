//
//  ItemDetailModel.swift
//  Embr
//
//  Created by Alex Ronquillo on 9/16/15.
//  Copyright (c) 2015 SeniorProject. All rights reserved.
//

import Foundation

class ItemDetailModel {
    
    var itemDetailHeadings = [String]()
    var itemToView: MediaItem? = nil
    static var instance: ItemDetailModel? = nil
    
    private init() {
        itemDetailHeadings = [
            "Reviews",
            "Blurb",
            "Comments"
        ]
    }
    
    static func getModel() -> ItemDetailModel {
        if instance == nil {
            instance = ItemDetailModel()
        }
        return instance!
    }
    
    func updateItemReview(mediaItem: MediaItem, review: Int) {
        // Perform update in database
        print("updated review to \(review) in db")
    }
    
    func searchForItems(searchCriteria: String) -> [MediaItem] {
        let user1 = User(id: "\(rand)", username: "Alex", parentalControls: nil)
        
        let genericLikeComment = Comment(id: "\(rand)", userWhoWroteTheComment: user1, subject: "Initial Comment", body: "Hey, I love this book! 👍. The book was long, but it was super interesting! I really loved the characters, the action, and the story.", isFlaggedAsInappropriate: false, parentComment: nil, rating: 0)
        
        let genericDislikeComment = Comment(id: "\(rand)", userWhoWroteTheComment: user1, subject: "Secondary Comment", body: "I don't like this book. It was dull and boring. The story was too long.", isFlaggedAsInappropriate: false, parentComment: genericLikeComment, rating: 0)
        
        let blurb1 = "Frodo Baggins knew the Ringwraiths were searching for him—and the Ring of Power he bore that would enable Sauron to destroy all that was good in Middle-earth. Now it was up to Frodo and his faithful servant Sam to carry the Ring to where it could be destroyed—in the very center of Sauron's dark kingdom."
        
        let mediaItem: MediaItem = Book(id: "\(rand)", title: "The Fellowship of the Ring", imageName: "FellowshipBookCover", blurb: blurb1, recommendedAgeForParentalControls: nil, currentUserReview: 5, avgFriendReview: nil, avgReview: 4.9, author: "J.R.R. Tolkien", pageCount: 500, publisher: "Houghton Mifflin", comments: [genericLikeComment, genericDislikeComment])
        
        let mediaItem2: MediaItem = Movie(id: "\(rand)", title: "Harry Potter and the Philosopher's Stone", imageName: "PhilosophersStoneCover", blurb: "This is the first book in the Harry Potter series", recommendedAgeForParentalControls: nil, currentUserReview: 5, avgFriendReview: 4.5, avgReview: 4.5, director: "Chris Columbus", allActors: ["Daniel Radcliffe", "Emma Watson"], allCrewExceptDirector: ["Steven Kloves", "David Heyman"], comments: [genericLikeComment, genericDislikeComment, genericLikeComment])
        
        let mediaItems = [mediaItem, mediaItem2]
        
        var mediaItemsThatMeetTheSearchCriteria = [MediaItem]()
        for item in mediaItems {
            if item.title.lowercaseString.containsString(searchCriteria.lowercaseString) {
                mediaItemsThatMeetTheSearchCriteria.append(item)
            }
        }
        return mediaItemsThatMeetTheSearchCriteria
            
    }
}