import Foundation

protocol MediaItem : AnyObject {
    var id: Int { get }
    var title: String { get }
    var imageName: String? { get }
    var blurb: String { get }
    var recommendedAge: Int? { get }
    var myReview: Int? { get }
    var avgFriendReview: Double? { get }
    var avgReview: Double? { get }
    var comments: [Comment] { get }
    var genres: [String] { get }
    var childItems: [MediaItem] { get }
    var parentId: Int? { get }
    
    func getAverageReviewString() -> String
}

class TelevisionShow : MediaItem {
    private(set) var id: Int
    private(set) var title: String
    private(set) var imageName: String?
    private(set) var blurb: String
    private(set) var recommendedAge: Int?
    private(set) var myReview: Int?
    private(set) var avgFriendReview: Double?
    private(set) var avgReview: Double?
    private(set) var runtime: String?
    private(set) var airDate: String?
    private(set) var channel: String?
    private(set) var genres: [String]
    private(set) var cast: String?
    private(set) var director: String
    private(set) var writer: String
    private(set) var rating: String?
    private(set) var childItems: [MediaItem]
    private(set) var parentId: Int?
    private(set) var comments: [Comment]
    
    init(mediaItemDictionary: NSDictionary) {
        id = mediaItemDictionary["id"] as! Int
        title = mediaItemDictionary["title"] as! String
        imageName = mediaItemDictionary["image"] as? String
        blurb = mediaItemDictionary["description"] as? String ?? "Description of the item"
        myReview = mediaItemDictionary["user_score"] as? Int
        avgReview = mediaItemDictionary["average_score"] as? Double
        airDate = mediaItemDictionary["airDate"] as? String ?? "Never Aired"
        channel = mediaItemDictionary["channel"] as? String ?? "No Channel"
        genres = mediaItemDictionary["genres"] as? [String] ?? []
        cast = mediaItemDictionary["actors"] as? String? ?? "No Actors"
        director = mediaItemDictionary["director"] as! String
        writer = mediaItemDictionary["writer"] as! String
        rating = mediaItemDictionary["rating"] as? String ?? "No Rating"
        parentId = mediaItemDictionary["parent_id"] as? Int
        childItems = [MediaItem]()
        if let childItemsArray = mediaItemDictionary["child_items"] as? NSArray {
            for item in childItemsArray {
                let mediaItemDictionary = item as! NSDictionary
                let child = parseMediaItem(mediaItemDictionary)
                childItems.append(child)
            }
        }
        comments = [Comment]()
        if let commentsArray = mediaItemDictionary["comments"] as? NSArray {
            comments = Comment.parseJsonComments(commentsOnItem: commentsArray, parentComment: nil)
        }
    }
    
    func getAverageReviewString() -> String {
        if avgReview == nil {
            return "None"
        }
        return "\(avgReview!)"
    }
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
    private(set) var publishDate: String?
    private(set) var numPages: Int?
    private(set) var authors: String?
    private(set) var publisher: String?
    private(set) var edition: String?
    private(set) var genres: [String]
    private(set) var childItems: [MediaItem]
    private(set) var parentId: Int?
    private(set) var comments: [Comment]
    
    init(mediaItemDictionary: NSDictionary) {
        id = mediaItemDictionary["id"] as! Int
        title = mediaItemDictionary["title"] as! String
        imageName = mediaItemDictionary["image"] as? String
        blurb = mediaItemDictionary["description"] as? String ?? "Description of the item"
        myReview = mediaItemDictionary["user_score"] as? Int
        avgReview = mediaItemDictionary["average_score"] as? Double
        publishDate = mediaItemDictionary["publishDate"] as? String ?? "No Publish Date"
        numPages = mediaItemDictionary["numPages"] as? Int
        authors = mediaItemDictionary["authors"] as? String ?? "No Author"
        publisher = mediaItemDictionary["publisher"] as? String ?? "Publisher"
        edition = mediaItemDictionary["edition"] as? String
        genres = mediaItemDictionary["genres"] as? [String] ?? []
        parentId = mediaItemDictionary["parent_id"] as? Int
        childItems = [MediaItem]()
        if let childItemsArray = mediaItemDictionary["child_items"] as? NSArray {
            for item in childItemsArray {
                let mediaItemDictionary = item as! NSDictionary
                let child = parseMediaItem(mediaItemDictionary)
                childItems.append(child)
            }
        }
        comments = [Comment]()
        if let commentsArray = mediaItemDictionary["comments"] as? NSArray {
            comments = Comment.parseJsonComments(commentsOnItem: commentsArray, parentComment: nil)
        }
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
    private(set) var rating: String?
    private(set) var releaseDate: String?
    private(set) var director: String
    private(set) var writer: String
    private(set) var studio: String?
    private(set) var cast: String?
    private(set) var genres: [String]
    private(set) var runtime: Int?
    private(set) var childItems: [MediaItem]
    private(set) var parentId: Int?
    private(set) var comments: [Comment]
    
    init(mediaItemDictionary: NSDictionary) {
        id = mediaItemDictionary["id"] as! Int
        title = mediaItemDictionary["title"] as! String
        imageName = mediaItemDictionary["image"] as? String
        blurb = mediaItemDictionary["description"] as? String ?? "Description of the item"
        myReview = mediaItemDictionary["user_score"] as? Int
        avgReview = mediaItemDictionary["average_score"] as? Double
        rating = mediaItemDictionary["rating"] as? String ?? "No Rating"
        director = mediaItemDictionary["director"] as! String
        writer = mediaItemDictionary["writer"] as! String
        studio = mediaItemDictionary["studio"] as? String ?? "No Studio"
        cast = mediaItemDictionary["actors"] as? String? ?? "No Cast"
        genres = mediaItemDictionary["genres"] as? [String] ?? []
        runtime = mediaItemDictionary["runtime"] as? Int
        parentId = mediaItemDictionary["parent_id"] as? Int
        childItems = [MediaItem]()
        if let childItemsArray = mediaItemDictionary["child_items"] as? NSArray {
            for item in childItemsArray {
                let mediaItemDictionary = item as! NSDictionary
                let child = parseMediaItem(mediaItemDictionary)
                childItems.append(child)
            }
        }
        comments = [Comment]()
        if let commentsArray = mediaItemDictionary["comments"] as? NSArray {
            comments = Comment.parseJsonComments(commentsOnItem: commentsArray, parentComment: nil)
        } else {
            comments = []
        }
    }
    
    func getAverageReviewString() -> String {
        if avgReview == nil {
            return "None"
        }
        return "\(avgReview!)"
    }
}

class Game : MediaItem {
    private(set) var id: Int
    private(set) var title: String
    private(set) var imageName: String?
    private(set) var blurb: String
    private(set) var recommendedAge: Int?
    private(set) var myReview: Int?
    private(set) var avgFriendReview: Double?
    private(set) var avgReview: Double?
    private(set) var publisher: String?
    private(set) var studio: String?
    private(set) var releaseDate: String?
    private(set) var rating: String?
    private(set) var length: Int?
    private(set) var multiplayer: Bool
    private(set) var singleplayer: Bool
    private(set) var genres: [String]
    private(set) var childItems: [MediaItem]
    private(set) var parentId: Int?
    private(set) var comments: [Comment]
    
    init(mediaItemDictionary: NSDictionary) {
        id = mediaItemDictionary["id"] as! Int
        title = mediaItemDictionary["title"] as! String
        imageName = mediaItemDictionary["image"] as? String
        blurb = mediaItemDictionary["description"] as? String ?? "Description of the item"
        myReview = mediaItemDictionary["user_score"] as? Int
        avgReview = mediaItemDictionary["average_score"] as? Double
        publisher = mediaItemDictionary["publisher"] as? String ?? "No Publiser"
        studio = mediaItemDictionary["studio"] as? String ?? "No Studio"
        releaseDate = mediaItemDictionary["releaseDate"] as? String ?? "No Release Date"
        rating = mediaItemDictionary["rating"] as? String ?? "No Rating"
        length = mediaItemDictionary["gameLength"] as? Int
        multiplayer = mediaItemDictionary["multiplayer"] as! Bool
        singleplayer = mediaItemDictionary["singleplayer"] as! Bool
        genres = mediaItemDictionary["genres"] as? [String] ?? []
        parentId = mediaItemDictionary["parent_id"] as? Int
        childItems = [MediaItem]()
        if let childItemsArray = mediaItemDictionary["child_items"] as? NSArray {
            for item in childItemsArray {
                let mediaItemDictionary = item as! NSDictionary
                let child = parseMediaItem(mediaItemDictionary)
                childItems.append(child)
            }
        }
        comments = [Comment]()
        if let commentsArray = mediaItemDictionary["comments"] as? NSArray {
            comments = Comment.parseJsonComments(commentsOnItem: commentsArray, parentComment: nil)
        } else {
            comments = []
        }
    }
    
    func getAverageReviewString() -> String {
        if avgReview == nil {
            return "None"
        }
        return "\(avgReview!)"
    }
}

class Music : MediaItem {
    private(set) var id: Int
    private(set) var title: String
    private(set) var imageName: String?
    private(set) var blurb: String
    private(set) var recommendedAge: Int?
    private(set) var myReview: Int?
    private(set) var avgFriendReview: Double?
    private(set) var avgReview: Double?
    private(set) var releaseDate: String?
    private(set) var recordingCompany: String?
    private(set) var artist: String?
    private(set) var genres: [String]
    private(set) var length: String?
    private(set) var childItems: [MediaItem]
    private(set) var parentId: Int?
    private(set) var comments: [Comment]
    
    init(mediaItemDictionary: NSDictionary) {
        id = mediaItemDictionary["id"] as! Int
        title = mediaItemDictionary["title"] as! String
        imageName = mediaItemDictionary["image"] as? String
        blurb = mediaItemDictionary["description"] as? String ?? "Description of the item"
        myReview = mediaItemDictionary["user_score"] as? Int
        avgReview = mediaItemDictionary["average_score"] as? Double
        releaseDate = mediaItemDictionary["releaseDate"] as? String
        recordingCompany = mediaItemDictionary["recordingCompany"] as? String
        artist = mediaItemDictionary["artist"] as? String
        genres = mediaItemDictionary["genres"] as? [String] ?? []
        length = mediaItemDictionary["length"] as? String
        parentId = mediaItemDictionary["parent_id"] as? Int
        childItems = [MediaItem]()
        if let childItemsArray = mediaItemDictionary["child_items"] as? NSArray {
            for item in childItemsArray {
                let mediaItemDictionary = item as! NSDictionary
                let child = parseMediaItem(mediaItemDictionary)
                childItems.append(child)
            }
        }
        comments = [Comment]()
        if let commentsArray = mediaItemDictionary["comments"] as? NSArray {
            comments = Comment.parseJsonComments(commentsOnItem: commentsArray, parentComment: nil)
        } else {
            comments = []
        }
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
    private(set) var comments: [Comment]
    private(set) var type: String
    private(set) var childItems: [MediaItem]
    private(set) var parentId: Int?
    private(set) var genres: [String]
    
    init(mediaItemDictionary: NSDictionary) {
        id = mediaItemDictionary["id"] as! Int
        title = mediaItemDictionary["title"] as! String
        imageName = mediaItemDictionary["image"] as? String
        blurb = mediaItemDictionary["description"] as? String ?? "Description of the item"
        type = mediaItemDictionary["type"] as! String
        parentId = mediaItemDictionary["parent_id"] as? Int
        genres = mediaItemDictionary["genres"] as? [String] ?? []
        childItems = [MediaItem]()
        if let childItemsArray = mediaItemDictionary["child_items"] as? NSArray {
            for item in childItemsArray {
                let mediaItemDictionary = item as! NSDictionary
                let child = parseMediaItem(mediaItemDictionary)
                childItems.append(child)
            }
        }
        comments = [Comment]()
        if let commentsArray = mediaItemDictionary["comments"] as? NSArray {
            comments = Comment.parseJsonComments(commentsOnItem: commentsArray, parentComment: nil)
        } else {
            comments = []
        }
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

func parseMediaItem(mediaItemDictionary: NSDictionary) -> MediaItem {
    switch mediaItemDictionary["type"] as! String {
    case "TV":
        return TelevisionShow(mediaItemDictionary: mediaItemDictionary)
    case "Movie":
        return Movie(mediaItemDictionary: mediaItemDictionary)
    case "Book":
        return Book(mediaItemDictionary: mediaItemDictionary)
    case "Game":
        return Game(mediaItemDictionary: mediaItemDictionary)
    case "Music":
        return Music(mediaItemDictionary: mediaItemDictionary)
    default:
        return GenericMediaItem(mediaItemDictionary: mediaItemDictionary)
    }
}
