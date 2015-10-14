import Foundation

protocol MediaItem {
    var id: Int { get }
    var title: String { get }
    var imageName: String? { get }
    var blurb: String { get }
    var recommendedAge: Int? { get }
    var myReview: Int? { get }
    var avgFriendReview: Double? { get }
    var avgReview: Double? { get }
    var comments: [Comment] { get }
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
    private(set) var author: String
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
        self.author = author
        self.pageCount = pageCount
        self.publisher = publisher
        self.comments = comments
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
    private(set) var director: String
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
        self.director = director
        self.cast = cast
        self.crew = crew
        self.comments = comments
    }
}

class BasicMediaItem: MediaItem {
    private(set) var id: Int
    private(set) var title: String
    private(set) var imageName: String?
    private(set) var blurb: String
    private(set) var recommendedAge: Int?
    private(set) var myReview: Int?
    private(set) var avgFriendReview: Double?
    private(set) var avgReview: Double?
    private(set) var creator: String?
    private(set) var comments: [Comment]
    
    init(id: Int, title: String?) {
        self.blurb = "Description of the story."
        self.creator = "Not Specified"
        self.id = id
        self.title = title!
        self.comments = []
    }
    
    static func parseBasicMediaItem(mediaItemDictionary: NSDictionary) -> BasicMediaItem {
        let id = mediaItemDictionary["id"] as! Int
        let title = mediaItemDictionary["title"] as? String
        return BasicMediaItem(id: id, title: title)
    }
}