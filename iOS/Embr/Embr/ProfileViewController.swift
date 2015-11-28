import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let librariesSegueIdentifier = "segueToLibraries"
    private let friendsSegueIdentifier = "segueToFriends"
    private let commentsSegueIdentifier = "segueToComments"
    
    var user: User?
    var feed = [Comment]()

    @IBOutlet weak var updates: UITableView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!

    override func viewDidLoad() {
        if user != nil {
            self.username.text = self.user!.username
            self.email.text = self.user!.email
            self.updates.estimatedRowHeight = 100.0
            self.updates.rowHeight = UITableViewAutomaticDimension
            self.updates.hidden = true
            
            let userId = UserDataSource.getUserID()
            if userId != self.user!.id {
                UserDataSource.checkFriend(self.user!.id, completionHandler: { (data, response, error) -> Void in
                    if data != nil {
                        do {
                            let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                            if jsonResponse["success"] as! Bool {
                                if !(jsonResponse["response"] as! Bool) {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Friend", style: UIBarButtonItemStyle.Plain, target: self, action: "addFriend")
                                    }
                                }
                            }
                        } catch {}
                    }
                })
            } else {
                self.updates.hidden = false
            }
            
            updates.delegate = self
            updates.dataSource = self
            UserDataSource.getUpdates({ (data, response, error) -> Void in
                if data != nil {
                    do {
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                        if jsonResponse["success"] as! Bool {
                            let commentsArray = jsonResponse["response"] as! [NSDictionary]
                            self.feed = Comment.parseJsonComments(commentsOnItem: commentsArray, parentComment: nil)
                            dispatch_async(dispatch_get_main_queue()) {
                                self.updates.reloadData()
                            }
                        }
                    } catch {}
                }
            })
        } else {
            navigationController!.popToRootViewControllerAnimated(true)
        }
    }
    
    func addFriend() {
        UserDataSource.addFriend(user!.id) { (data, response, error) -> Void in
            if data != nil {
                do {
                    let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    if jsonResponse["success"] as! Bool == false {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.alertError(errorMessage: jsonResponse["response"] as? String ?? "Friend not added")
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.navigationItem.rightBarButtonItem = nil
                        }
                    }
                } catch {}
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feed.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reusableCellIdentifier = "cellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(reusableCellIdentifier)

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reusableCellIdentifier)
        }
        
        let comment = self.feed[indexPath.row]
        let update = "Your comment got a response!\n\(comment.author.username) said \"\(comment.body)\""
        cell!.textLabel!.text = update
        
        cell!.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell!.textLabel!.numberOfLines = 0
        
        return cell!
    }

    @IBAction func viewFriends(sender: UIButton) {
        UserDataSource.getFriendsList(user!.id) { (data, response, error) -> Void in
            if data != nil {
                do {
                    let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    if jsonResponse["success"] as! Bool {
                        
                        if let friendsArray = jsonResponse["response"] as? NSArray {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.performSegueWithIdentifier(self.friendsSegueIdentifier, sender: friendsArray)
                            }
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.alertError(errorMessage: jsonResponse["response"] as! String)
                        }
                    }
                } catch {}
            }
        }
    }
    
    @IBAction func attemptOpenLibraries(sender: UIButton) {
        goToLibraries()
    }
    
    func goToLibraries() {
        LibrariesDataSource.getMyLibraries(user!.id, completionHandler: { (data, response, error) -> Void in
            if data != nil {
                do {
                    let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    if jsonResponse["success"] as! Bool {
                        if let response = jsonResponse["response"] as? NSArray {
                            if response.count > 0 {
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.performSegueWithIdentifier(self.librariesSegueIdentifier, sender: response)
                                }
                            }
                        } else {
                            let jsonError = jsonResponse["response"]
                            let errorMsg = "Invalid response from GetLibrariesList.py:\n\(jsonError)"
                            print(errorMsg)
                        }
                    } else {
                        let jsonError = jsonResponse["response"]
                        let errorMsg = "Invalid response from GetLibrariesList.py:\n\(jsonError)"
                        print(errorMsg)
                    }
                } catch {
                    let errorMsg = "Invalid data from GetLibrariesList.py"
                    print(errorMsg)
                }
            }
        })
    }

    
    func loginCompletionHandler (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void {
        if data != nil {
            do {
                let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                if jsonResponse["success"] as! Bool {
                    if let session = jsonResponse["response"] as? String {
                        succesfulLogin(sessionId: session)
                    }
                } else if jsonResponse["response"] != nil {
                    alertError(errorMessage: "Invalid login")
                }
            } catch {
                alertError(errorMessage: "Invalid response")
            }
        }
    }
    
    private func alertError(errorMessage error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        dispatch_async(dispatch_get_main_queue()){
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private func succesfulLogin(sessionId session: String) {
        dispatch_async(dispatch_get_main_queue()) {
            SessionModel.storeSession(sessionId: session)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == librariesSegueIdentifier && sender is NSArray {
            let destination = segue.destinationViewController as! LibrariesListTableViewController
            let libraries = parseLibraryList(librariesArray: sender as! NSArray)
            destination.librariesList = libraries
            destination.userId = self.user!.id
        } else if segue.identifier == friendsSegueIdentifier && sender is NSArray {
            if let destination = segue.destinationViewController as? FriendsListTableViewController {
                for friend in sender as! NSArray {
                    let friendDict = friend as! NSDictionary
                    let user = User.parseUser(friendDict)
                    destination.friends.append(user)
                }
                destination.user = self.user
            }
        } else if segue.identifier == commentsSegueIdentifier && sender is Comment {
            if let destination = segue.destinationViewController as? CommentsViewController {
                destination.comments.removeAll()
                let selectedComment = sender as! Comment
                destination.comments.append(selectedComment)
                destination.comments.appendContentsOf(selectedComment.children)
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let comment = self.feed[indexPath.row]
        if let parent = comment.parent {
            performSegueWithIdentifier(commentsSegueIdentifier, sender: parent)
        }
    }
}
