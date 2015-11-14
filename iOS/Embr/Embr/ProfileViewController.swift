import UIKit

class ProfileViewController: UIViewController {
    
    private let librariesSegueIdentifier = "segueToLibraries"
    private let friendsSegueIdentifier = "segueToFriends"
    
    var user: User?
    var notMe = true

    @IBOutlet weak var updates: UITableView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!

    override func viewDidLoad() {
        if user != nil {
            self.username.text = user!.username
            self.email.text = user!.email
            if notMe {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Friend", style: UIBarButtonItemStyle.Plain, target: self, action: "addFriend")
            }
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
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reusableCellIdentifier = "cellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(reusableCellIdentifier)

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reusableCellIdentifier)
        }
        
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
        } else if segue.identifier == friendsSegueIdentifier && sender is NSArray {
            if let destination = segue.destinationViewController as? FriendsListTableViewController {
                for friend in sender as! NSArray {
                    let friendDict = friend as! NSDictionary
                    let user = User.parseUser(friendDict)
                    destination.friends.append(user)
                    destination.isMe = !notMe
                }
            }
        }
    }
}
