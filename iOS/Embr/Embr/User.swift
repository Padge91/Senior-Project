import Foundation

class User {
    private(set) var id: Int
    private(set) var username: String
    private(set) var email: String
    private(set) var friends: [User]
    private(set) var parentalControls: ParentalControls?
    
    init(id: Int, username: String, email: String = "No Email", parentalControls: ParentalControls?, friends: [User] = []) {
        self.id = id
        self.username = username
        self.friends = friends
        self.email = email
        self.parentalControls = parentalControls
    }
    
    static func parseUser(dict: NSDictionary) -> User {
        let id = dict["id"] as! Int
        let username = dict["username"] as! String
        let email = dict["email"] as! String
        return User(id: id, username: username, email: email, parentalControls: nil)
    }
    
    func addFriend(friend: User) {
        for user in friends {
            if user.equals(friend) {
                return
            }
        }
        friends.append(friend)
    }
    
    func removeFriend(friendUsername: String) {
        var removeIndex: Int? = nil
        let max = friends.count - 1
        for (var i = 0; i <= max; ++i) {
            removeIndex = i
            break
        }
        if removeIndex != nil {
            friends.removeAtIndex(removeIndex!)
        }
    }
    
    func equals(anotherUser: User) -> Bool {
        return id == anotherUser.id
    }
}

class ParentalControls {
    
}