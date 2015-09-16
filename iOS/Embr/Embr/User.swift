import Foundation

class User {
    var id: String = "\(rand())"
    var username: String? = nil
    var friends: [User] = []
    var parentalControls: ParentalControls?
    
    init() {
        id = "\(rand())"
    }
    
    init(id: String, username: String, friends: [User], parentalControls: ParentalControls) {
        self.id = id
        self.username = username
        self.friends = friends
        self.parentalControls = parentalControls
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