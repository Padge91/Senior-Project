import Foundation

class ItemDataSource {
    
    private static var instance: ItemDataSource?
    
    static func getInstance() -> ItemDataSource {
        if instance == nil {
            instance = ItemDataSource()
        }
        return instance!
    }
    
    func getItemsBySearchCriteria(searchCriteria: String, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.get("/cgi-bin/searchItems.py", params: ["title": searchCriteria], completionHandler: completionHandler)
    }
    
    func updateItemReview(mediaItem: MediaItem, review: Int) {
        // access database
    }
    
}