import Foundation

class MediaItem {
    private(set) var id: Int
    private(set) var title: String?
    private(set) var imageName: String? 
    private(set) var blurb: String?
    private(set) var recommendedAge: Int? 
    private(set) var myReview: Int? 
    private(set) var avgFriendReview: Double? 
    private(set) var avgReview: Double?
    private(set) var type: String?
    private(set) var comments: [Comment] 
    private(set) var genres: [String] 
    private(set) var childItems: [MediaItem] 
    private(set) var parentId: Int? 
    
    init(mediaItemDictionary: NSDictionary) {
        id = mediaItemDictionary["id"] as! Int
        title = mediaItemDictionary["title"] as? String ?? "No Title"
        imageName = mediaItemDictionary["image"] as? String
        blurb = mediaItemDictionary["description"] as? String ?? "Description of the item"
        myReview = mediaItemDictionary["user_score"] as? Int
        avgReview = mediaItemDictionary["average_score"] as? Double
        type = mediaItemDictionary["type"] as? String ?? "None"
        parentId = mediaItemDictionary["parent_id"] as? Int
        genres = mediaItemDictionary["genres"] as? [String] ?? []
        childItems = [MediaItem]()
        if let childItemsArray = mediaItemDictionary["child_items"] as? NSArray {
            for item in childItemsArray {
                if let mediaItemDictionary = item as? NSDictionary {
                    let child = parseMediaItem(mediaItemDictionary)
                    childItems.append(child)
                }
            }
        }
        comments = [Comment]()
        if let commentsArray = mediaItemDictionary["comments"] as? NSArray {
            comments = Comment.parseJsonComments(commentsOnItem: commentsArray, parentComment: nil)
        } else {
            comments = []
        }
    }
    
    func getAverageFriendReviewString() -> String {
        if avgFriendReview == nil {
            return "None"
        }
        return "\(avgFriendReview!)"
    }
    
    func getAverageReviewString() -> String {
        if avgReview == nil {
            return "None"
        }
        return "\(avgReview!)"
    }
}

class TelevisionShow : MediaItem {
    private(set) var runtime: String?
    private(set) var airDate: String?
    private(set) var channel: String?
    private(set) var cast: String?
    private(set) var director: String?
    private(set) var writer: String?
    private(set) var rating: String?
    
    override init(mediaItemDictionary: NSDictionary) {
        super.init(mediaItemDictionary: mediaItemDictionary)
        airDate = mediaItemDictionary["airDate"] as? String ?? "Never Aired"
        channel = mediaItemDictionary["channel"] as? String ?? "No Channel"
        cast = mediaItemDictionary["actors"] as? String? ?? "No Actors"
        director = mediaItemDictionary["director"] as? String ?? "No Director"
        writer = mediaItemDictionary["writer"] as? String ?? "No Writer"
        rating = mediaItemDictionary["rating"] as? String ?? "No Rating"
    }
}

class Book : MediaItem {
    private(set) var publishDate: String?
    private(set) var numPages: Int?
    private(set) var authors: String?
    private(set) var publisher: String?
    private(set) var edition: String?
    
    override init(mediaItemDictionary: NSDictionary) {
        super.init(mediaItemDictionary: mediaItemDictionary)
        publishDate = mediaItemDictionary["publishDate"] as? String ?? "No Publish Date"
        numPages = mediaItemDictionary["numPages"] as? Int
        authors = mediaItemDictionary["authors"] as? String ?? "No Author"
        publisher = mediaItemDictionary["publisher"] as? String ?? "No Publisher"
        edition = mediaItemDictionary["edition"] as? String ?? "No Edition"
    }
}

class Movie : MediaItem {
    private(set) var rating: String?
    private(set) var releaseDate: String?
    private(set) var director: String?
    private(set) var writer: String?
    private(set) var studio: String?
    private(set) var cast: String?
    private(set) var runtime: Int?
    
    override init(mediaItemDictionary: NSDictionary) {
        super.init(mediaItemDictionary: mediaItemDictionary)
        rating = mediaItemDictionary["rating"] as? String ?? "No Rating"
        director = mediaItemDictionary["director"] as? String ?? "No Director"
        writer = mediaItemDictionary["writer"] as? String ?? "No Writer"
        studio = mediaItemDictionary["studio"] as? String ?? "No Studio"
        cast = mediaItemDictionary["actors"] as? String? ?? "No Cast"
    }
}

class Game : MediaItem {
    private(set) var publisher: String?
    private(set) var studio: String?
    private(set) var releaseDate: String?
    private(set) var rating: String?
    private(set) var length: Int?
    private(set) var multiplayer = false
    private(set) var singleplayer = false
    
    override init(mediaItemDictionary: NSDictionary) {
        super.init(mediaItemDictionary: mediaItemDictionary)
        publisher = mediaItemDictionary["publisher"] as? String ?? "No Publisher"
        studio = mediaItemDictionary["studio"] as? String ?? "No Studio"
        releaseDate = mediaItemDictionary["releaseDate"] as? String ?? "No Release Date"
        rating = mediaItemDictionary["rating"] as? String ?? "No Rating"
        length = mediaItemDictionary["gameLength"] as? Int
        multiplayer = mediaItemDictionary["multiplayer"] as! Bool
        singleplayer = mediaItemDictionary["singleplayer"] as! Bool
    }
}

class Music : MediaItem {
    private(set) var releaseDate: String?
    private(set) var recordingCompany: String?
    private(set) var artist: String?
    private(set) var length: String?
    
    override init(mediaItemDictionary: NSDictionary) {
        super.init(mediaItemDictionary: mediaItemDictionary)
        recordingCompany = mediaItemDictionary["recordingCompany"] as? String
        artist = mediaItemDictionary["artist"] as? String ?? "No Artist"
        genres = mediaItemDictionary["genres"] as? [String] ?? []
        length = mediaItemDictionary["length"] as? String ?? "No Length"
    }
}

class MediaItemList : AnyObject {
    var list = [MediaItem]()
    
    init(mediaItemList: [MediaItem]) {
        self.list = mediaItemList
    }
}

func parseMediaItem(mediaItemDictionary: NSDictionary) -> MediaItem {
    if let type = mediaItemDictionary["type"] as? String {
        switch type {
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
            break;
        }
    } else {
        printError("Media Item", errorMessage: "Type is nil for id \(mediaItemDictionary["id"]!)")
    }
    return MediaItem(mediaItemDictionary: mediaItemDictionary)
}
