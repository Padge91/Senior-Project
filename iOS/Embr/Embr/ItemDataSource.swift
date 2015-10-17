import Foundation

class ItemDataSource {
    
    static func getItemsBySearchCriteria(searchCriteria: String, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.get("/cgi-bin/SearchItems.py", params: ["title": searchCriteria], completionHandler: completionHandler)
    }
    
    static func updateItemReview(mediaItem: MediaItem, review: Int, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.put("/cgi-bin/SubmitReview.py", httpBody:
            "session=\(SessionModel.getSession())&" +
            "item_id=\(mediaItem.id)&" +
            "score=\(review)", completionHandler: completionHandler)
    }
    
    static func getItem(session: String, id: Int, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.get("/cgi-bin/GetItemInfo.py", params: ["session": session, "id": "\(id)"], completionHandler: completionHandler)
    }
    
}