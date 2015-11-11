import Foundation

protocol MediaItem : AnyObject {
    var id: Int { get }
    var title: String { get }
    var creator: String { get }
    var imageName: String? { get }
    var blurb: String { get }
    var recommendedAge: Int? { get }
    var myReview: Int? { get }
    var avgFriendReview: Double? { get }
    var avgReview: Double? { get }
    var comments: [Comment] { get }
    
    func getAverageReviewString() -> String
}

class Book : MediaItem {
    private(set) var id: Int
    private(set) var title: String
    private(set) var imageName: String?
    private(set) var blurb: String
    private(set) var recommendedAge: Int?
    private(set) var myReview: Int?
    private(set) var avgFriendReview: Double?
    private(set) var avgReview: Double?
    private(set) var creator: String
    private(set) var pageCount: Int
    private(set) var publisher: String
    private(set) var comments: [Comment]
    
    init(id: Int, title: String, imageName: String?, blurb: String, recommendedAgeForParentalControls recommendedAge: Int?, currentUserReview myReview: Int?, avgFriendReview: Double?, avgReview: Double?, author: String, pageCount: Int, publisher: String, comments: [Comment]) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.blurb = blurb
        self.recommendedAge = recommendedAge
        self.myReview = myReview
        self.avgFriendReview = avgFriendReview
        self.avgReview = avgReview
        self.creator = author
        self.pageCount = pageCount
        self.publisher = publisher
        self.comments = comments
    }
    
    func getAverageReviewString() -> String {
        if avgReview == nil {
            return "None"
        }
        return "\(avgReview!)"
    }
}

class Movie : MediaItem {
    private(set) var id: Int
    private(set) var title: String
    private(set) var imageName: String?
    private(set) var blurb: String
    private(set) var recommendedAge: Int?
    private(set) var myReview: Int?
    private(set) var avgFriendReview: Double?
    private(set) var avgReview: Double?
    private(set) var creator: String
    private(set) var cast: [String]
    private(set) var crew: [String]
    private(set) var comments: [Comment]
    
    init(id: Int, title: String, imageName: String?, blurb: String, recommendedAgeForParentalControls recommendedAge: Int?, currentUserReview myReview: Int?, avgFriendReview: Double?, avgReview: Double?, director: String,allActors cast: [String], allCrewExceptDirector crew: [String], comments: [Comment]) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.blurb = blurb
        self.recommendedAge = recommendedAge
        self.myReview = myReview
        self.avgFriendReview = avgFriendReview
        self.avgReview = avgReview
        self.creator = director
        self.cast = cast
        self.crew = crew
        self.comments = comments
    }
    
    func getAverageReviewString() -> String {
        if avgReview == nil {
            return "None"
        }
        return "\(avgReview!)"
    }
}

class GenericMediaItem: MediaItem {
    private(set) var id: Int
    private(set) var title: String
    private(set) var imageName: String?
    private(set) var blurb: String
    private(set) var recommendedAge: Int?
    private(set) var myReview: Int?
    private(set) var avgFriendReview: Double?
    private(set) var avgReview: Double?
    private(set) var creator: String
    private(set) var comments: [Comment]
    
    init(id: Int, title: String, imageName: String?, blurb: String, recommendedAge: Int?, myReview: Int?, avgReview: Double?, creator: String, comments: [Comment]) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.blurb = blurb
        self.recommendedAge = recommendedAge
        self.myReview = myReview
        self.avgReview = avgReview
        self.creator = creator
        self.comments = comments
    }
    
    static func parseGenericMediaItem(mediaItemDictionary: NSDictionary) -> GenericMediaItem {
        let id = mediaItemDictionary["id"] as! Int
        let title = mediaItemDictionary["title"] as! String
        let imageName = mediaItemDictionary["image"] as? String
        let blurb = mediaItemDictionary["description"] as? String ?? "Description of the item"
        let myReview = mediaItemDictionary["user_score"] as? Int
        let avgReview = mediaItemDictionary["average_score"] as? Double
        let creator = mediaItemDictionary["creator"] as? String ?? "Not Specified"
        var comments = [Comment]()
        if let commentsArray = mediaItemDictionary["comments"] as? NSArray {
            comments = Comment.parseJsonComments(commentsOnItem: commentsArray, parentComment: nil)
        } else {
            comments = []
        }
        return GenericMediaItem(id: id, title: title, imageName: imageName, blurb: blurb, recommendedAge: nil, myReview: myReview, avgReview: avgReview, creator: creator, comments: comments)
    }
    
    func getAverageReviewString() -> String {
        if avgReview == nil {
            return "None"
        }
        return "\(avgReview!)"
    }
}

class MediaItemList : AnyObject {
    var list = [MediaItem]()
    
    init(mediaItemList: [MediaItem]) {
        self.list = mediaItemList
    }
}