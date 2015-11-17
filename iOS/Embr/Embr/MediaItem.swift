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
    private(set) var comments: [Comment]
    
    init(id: Int, title: String, imageName: String?, blurb: String, recommendedAgeForParentalControls recommendedAge: Int?, currentUserReview myReview: Int?, avgFriendReview: Double?, avgReview: Double?, runtime: String?, dateTheShowFirstAired airDate: String?, channel: String?, genres: [String], actors cast: String?, director: String, writer: String, rating: String?, comments: [Comment]) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.blurb = blurb
        self.recommendedAge = recommendedAge
        self.myReview = myReview
        self.avgFriendReview = avgFriendReview
        self.avgReview = avgReview
        self.runtime = runtime
        self.airDate = airDate
        self.channel = channel
        self.genres = genres
        self.cast = cast
        self.director = director
        self.writer = writer
        self.rating = rating
        self.comments = comments
    }
    
    static func parseTvShow(mediaItemDictionary: NSDictionary) -> TelevisionShow {
        let id = mediaItemDictionary["id"] as! Int
        let title = mediaItemDictionary["title"] as! String
        let imageName = mediaItemDictionary["image"] as? String
        let blurb = mediaItemDictionary["description"] as? String ?? "Description of the item"
        let myReview = mediaItemDictionary["user_score"] as? Int
        let avgReview = mediaItemDictionary["average_score"] as? Double
        let airDate = mediaItemDictionary["airDate"] as? String ?? "Never Aired"
        let channel = mediaItemDictionary["channel"] as? String ?? "No Channel"
        let genres = mediaItemDictionary["genres"] as? [String] ?? []
        let cast = mediaItemDictionary["actors"] as? String? ?? "No Actors"
        let director = mediaItemDictionary["director"] as! String
        let writer = mediaItemDictionary["writer"] as! String
        let rating = mediaItemDictionary["rating"] as? String ?? "No Rating"
        var comments = [Comment]()
        if let commentsArray = mediaItemDictionary["comments"] as? NSArray {
            comments = Comment.parseJsonComments(commentsOnItem: commentsArray, parentComment: nil)
        } else {
            comments = []
        }
        let tvShow = TelevisionShow(id: id, title: title, imageName: imageName, blurb: blurb, recommendedAgeForParentalControls: nil, currentUserReview: myReview, avgFriendReview: nil, avgReview: avgReview, runtime: nil, dateTheShowFirstAired: airDate, channel: channel, genres: genres, actors: cast, director: director, writer: writer, rating: rating, comments: comments)
        return tvShow
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
    private(set) var comments: [Comment]
    
    init(id: Int, title: String, imageName: String?, blurb: String, recommendedAgeForParentalControls recommendedAge: Int?, currentUserReview myReview: Int?, avgFriendReview: Double?, avgReview: Double?, publishDate: String?, numPages: Int?, authors: String?, publisher: String?, edition: String?, genres: [String], comments: [Comment]) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.blurb = blurb
        self.recommendedAge = recommendedAge
        self.myReview = myReview
        self.avgFriendReview = avgFriendReview
        self.avgReview = avgReview
        self.publishDate = publishDate
        self.numPages = numPages
        self.authors = authors
        self.publisher = publisher
        self.edition = edition
        self.genres = genres
        self.comments = comments
    }
    
    static func parseBook(mediaItemDictionary: NSDictionary) -> Book {
        let id = mediaItemDictionary["id"] as! Int
        let title = mediaItemDictionary["title"] as! String
        let imageName = mediaItemDictionary["image"] as? String
        let blurb = mediaItemDictionary["description"] as? String ?? "Description of the item"
        let myReview = mediaItemDictionary["user_score"] as? Int
        let avgReview = mediaItemDictionary["average_score"] as? Double
        let publishDate = mediaItemDictionary["publishDate"] as? String ?? "No Publish Date"
        let numPages = mediaItemDictionary["numPages"] as? Int
        let authors = mediaItemDictionary["authors"] as? String ?? "No Author"
        let publisher = mediaItemDictionary["publisher"] as? String ?? "Publisher"
        let edition = mediaItemDictionary["edition"] as? String
        let genres = mediaItemDictionary["genres"] as? [String] ?? []
        var comments = [Comment]()
        if let commentsArray = mediaItemDictionary["comments"] as? NSArray {
            comments = Comment.parseJsonComments(commentsOnItem: commentsArray, parentComment: nil)
        } else {
            comments = []
        }
        let book = Book(id: id, title: title, imageName: imageName, blurb: blurb, recommendedAgeForParentalControls: nil, currentUserReview: myReview, avgFriendReview: nil, avgReview: avgReview, publishDate: publishDate, numPages: numPages, authors: authors, publisher: publisher, edition: edition, genres: genres, comments: comments)
        return book
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
    private(set) var comments: [Comment]
    
    init(id: Int, title: String, imageName: String?, blurb: String, recommendedAgeForParentalControls recommendedAge: Int?, currentUserReview myReview: Int?, avgFriendReview: Double?, avgReview: Double?, rating: String?, director: String, writer: String, studio: String?, cast: String?, genres: [String], runtime: Int?, comments: [Comment]) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.blurb = blurb
        self.recommendedAge = recommendedAge
        self.myReview = myReview
        self.avgFriendReview = avgFriendReview
        self.avgReview = avgReview
        self.rating = rating
        self.director = director
        self.writer = writer
        self.studio = studio
        self.cast = cast
        self.genres = genres
        self.runtime = runtime
        self.comments = comments
    }
    
    static func parseMovie(mediaItemDictionary: NSDictionary) -> Movie {
        let id = mediaItemDictionary["id"] as! Int
        let title = mediaItemDictionary["title"] as! String
        let imageName = mediaItemDictionary["image"] as? String
        let blurb = mediaItemDictionary["description"] as? String ?? "Description of the item"
        let myReview = mediaItemDictionary["user_score"] as? Int
        let avgReview = mediaItemDictionary["average_score"] as? Double
        let rating = mediaItemDictionary["rating"] as? String ?? "No Rating"
        let director = mediaItemDictionary["director"] as! String
        let writer = mediaItemDictionary["writer"] as! String
        let studio = mediaItemDictionary["studio"] as? String ?? "No Studio"
        let cast = mediaItemDictionary["actors"] as? String? ?? "No Cast"
        let genres = mediaItemDictionary["genres"] as? [String] ?? []
        let runtime = mediaItemDictionary["runtime"] as? Int
        var comments = [Comment]()
        if let commentsArray = mediaItemDictionary["comments"] as? NSArray {
            comments = Comment.parseJsonComments(commentsOnItem: commentsArray, parentComment: nil)
        } else {
            comments = []
        }
        return Movie(id: id, title: title, imageName: imageName, blurb: blurb, recommendedAgeForParentalControls: nil, currentUserReview: myReview, avgFriendReview: nil, avgReview: avgReview, rating: rating, director: director, writer: writer, studio: studio, cast: cast, genres: genres, runtime: runtime, comments: comments)
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
    private(set) var comments: [Comment]
    
    init(id: Int, title: String, imageName: String?, blurb: String, recommendedAgeForParentalControls recommendedAge: Int?, currentUserReview myReview: Int?, avgFriendReview: Double?, avgReview: Double?, publisher: String?, studio: String?, releaseDate: String?, rating: String?, length: Int?, multiplayer: Bool, singleplayer: Bool, genres: [String], comments: [Comment]) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.blurb = blurb
        self.recommendedAge = recommendedAge
        self.myReview = myReview
        self.avgFriendReview = avgFriendReview
        self.avgReview = avgReview
        self.publisher = publisher
        self.studio = studio
        self.releaseDate = releaseDate
        self.rating = rating
        self.length = length
        self.multiplayer = multiplayer
        self.singleplayer = singleplayer
        self.genres = genres
        self.comments = comments
    }
    
    static func parseGame(mediaItemDictionary: NSDictionary) -> Game {
        let id = mediaItemDictionary["id"] as! Int
        let title = mediaItemDictionary["title"] as! String
        let imageName = mediaItemDictionary["image"] as? String
        let blurb = mediaItemDictionary["description"] as? String ?? "Description of the item"
        let myReview = mediaItemDictionary["user_score"] as? Int
        let avgReview = mediaItemDictionary["average_score"] as? Double
        let publisher = mediaItemDictionary["publisher"] as? String ?? "No Publiser"
        let studio = mediaItemDictionary["studio"] as? String ?? "No Studio"
        let releaseDate = mediaItemDictionary["releaseDate"] as? String ?? "No Release Date"
        let rating = mediaItemDictionary["rating"] as? String ?? "No Rating"
        let length = mediaItemDictionary["gameLength"] as? Int
        let multiplayer = mediaItemDictionary["multiplayer"] as! Bool
        let singleplayer = mediaItemDictionary["singleplayer"] as! Bool
        let genres = mediaItemDictionary["genres"] as? [String] ?? []
        var comments = [Comment]()
        if let commentsArray = mediaItemDictionary["comments"] as? NSArray {
            comments = Comment.parseJsonComments(commentsOnItem: commentsArray, parentComment: nil)
        } else {
            comments = []
        }
        return Game(id: id, title: title, imageName: imageName, blurb: blurb, recommendedAgeForParentalControls: nil, currentUserReview: myReview, avgFriendReview: nil, avgReview: avgReview, publisher: publisher, studio: studio, releaseDate: releaseDate, rating: rating, length: length, multiplayer: multiplayer, singleplayer: singleplayer, genres: genres, comments: comments)
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
    private(set) var comments: [Comment]
    
    init(id: Int, title: String, imageName: String?, blurb: String, recommendedAgeForParentalControls recommendedAge: Int?, currentUserReview myReview: Int?, avgFriendReview: Double?, avgReview: Double?, releaseDate: String?, recordingCompany: String?, artist: String?, genres: [String], length: String?, comments: [Comment]) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.blurb = blurb
        self.recommendedAge = recommendedAge
        self.myReview = myReview
        self.avgFriendReview = avgFriendReview
        self.avgReview = avgReview
        self.releaseDate = releaseDate
        self.recordingCompany = recordingCompany
        self.artist = artist
        self.genres = genres
        self.length = length
        self.comments = comments
    }
    
    static func parseMusic(mediaItemDictionary: NSDictionary) -> Music {
        let id = mediaItemDictionary["id"] as! Int
        let title = mediaItemDictionary["title"] as! String
        let imageName = mediaItemDictionary["image"] as? String
        let blurb = mediaItemDictionary["description"] as? String ?? "Description of the item"
        let myReview = mediaItemDictionary["user_score"] as? Int
        let avgReview = mediaItemDictionary["average_score"] as? Double
        let releaseDate = mediaItemDictionary["releaseDate"] as? String
        let recordingCompany = mediaItemDictionary["recordingCompany"] as? String
        let artist = mediaItemDictionary["artist"] as? String
        let genres = mediaItemDictionary["genres"] as? [String] ?? []
        let length = mediaItemDictionary["length"] as? String
        var comments = [Comment]()
        if let commentsArray = mediaItemDictionary["comments"] as? NSArray {
            comments = Comment.parseJsonComments(commentsOnItem: commentsArray, parentComment: nil)
        } else {
            comments = []
        }
        return Music(id: id, title: title, imageName: imageName, blurb: blurb, recommendedAgeForParentalControls: nil, currentUserReview: myReview, avgFriendReview: nil, avgReview: avgReview, releaseDate: releaseDate, recordingCompany: recordingCompany, artist: artist, genres: genres, length: length, comments: comments)
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
    private(set) var type: String
    private(set) var genres: [String]
    
    init(id: Int, title: String, imageName: String?, blurb: String, recommendedAge: Int?, myReview: Int?, avgReview: Double?, creator: String, comments: [Comment], type: String) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.blurb = blurb
        self.recommendedAge = recommendedAge
        self.myReview = myReview
        self.avgReview = avgReview
        self.creator = creator
        self.comments = comments
        self.type = type
        self.genres = []
    }
    
    static func parseGenericMediaItem(mediaItemDictionary: NSDictionary) -> GenericMediaItem {
        let id = mediaItemDictionary["id"] as! Int
        let title = mediaItemDictionary["title"] as! String
        let imageName = mediaItemDictionary["image"] as? String
        let blurb = mediaItemDictionary["description"] as? String ?? "Description of the item"
        let creator = mediaItemDictionary["creator"] as? String ?? "Not Specified"
        let type = mediaItemDictionary["type"] as! String
        var comments = [Comment]()
        if let commentsArray = mediaItemDictionary["comments"] as? NSArray {
            comments = Comment.parseJsonComments(commentsOnItem: commentsArray, parentComment: nil)
        } else {
            comments = []
        }
        return GenericMediaItem(id: id, title: title, imageName: imageName, blurb: blurb, recommendedAge: nil, myReview: nil, avgReview: nil, creator: creator, comments: comments, type: type)
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
        return TelevisionShow.parseTvShow(mediaItemDictionary)
    case "Movie":
        return Movie.parseMovie(mediaItemDictionary)
    case "Book":
        return Book.parseBook(mediaItemDictionary)
    case "Game":
        return Game.parseGame(mediaItemDictionary)
    case "Music":
        return Music.parseMusic(mediaItemDictionary)
    default:
        return GenericMediaItem.parseGenericMediaItem(mediaItemDictionary)
    }
}