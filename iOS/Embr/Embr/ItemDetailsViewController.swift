import UIKit

class ItemDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let errorHeader = "Item Details View Controller"
    private let librariesSegueIdentifier = "segueToLibraries"
    private let commentsSegueIdentifier = "segueToComments"
    private let commentCreatorSegueIdentifier = "segueToCommentCreator"
    private let menuSegueIdentifier = "segueToMenu"
    private let moreInfoSegueIdentifier = "segueToMoreInfo"
    private let sectionHeadings = ["", "Reviews", "Blurb", "More", "Comments"]
    private let detailsSection = 0, reviewsSection = 1, blurbSection = 2, moreSection = 3, commentsSection = 4
    
    private var mediaItem: MediaItem? = nil
    private var itemDetails = [String: [AnyObject]]()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var itemDetailsTableView: UITableView!
    @IBOutlet var reviewCollection: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(mediaItem != nil)
        loadTitle()
        loadImage()
        loadMyReview()
        setupItemDetailsTable()
        setupNavigation()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func goToMenu() {
        performSegueWithIdentifier(menuSegueIdentifier, sender: nil)
    }
    
    private func setupItemDetailsTable() {
        itemDetailsTableView.dataSource = self
        itemDetailsTableView.delegate = self
        itemDetailsTableView.estimatedRowHeight = 100.0
        itemDetailsTableView.rowHeight = UITableViewAutomaticDimension
        itemDetailsTableView.backgroundColor = UIColor.whiteColor()
    }
    
    private func setupNavigation() {
        let menuItem = UIBarButtonItem(title: "Menu", style: .Plain, target: self, action: "goToMenu")
        let librariesItem = UIBarButtonItem(title: "My Libraries", style: .Plain, target: self, action: "attemptToOpenLibraries")
        navigationItem.rightBarButtonItem = menuItem
        let librariesButton = librariesItem
        toolbarItems = [librariesButton]
    }
    
    private func loadTitle() {
        assert(mediaItem != nil)
        titleLabel.text = mediaItem!.title
    }
    
    private func loadImage() {
        assert(mediaItem != nil)
        if let imageName = mediaItem!.imageName {
            if let imageURL = NSURL(string: imageName) {
                if let imageData = NSData(contentsOfURL: imageURL) {
                    coverImageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    @IBAction func goToMoreInfo(sender: UIButton) {
        performSegueWithIdentifier(moreInfoSegueIdentifier, sender: nil)
    }
    
    private func loadMyReview() {
        assert(mediaItem != nil)
        if let review = mediaItem!.myReview {
            for i in 0...4 {
                let star = reviewCollection[i]
                if i < review {
                    star.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
                } else {
                    star.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                }
            }
        }
    }
    
    func setMediaItem(item: MediaItem) {
        mediaItem = item
        itemDetails = [
            sectionHeadings[detailsSection]: [
                "Details",
                "Add to Library",
                "Add a Comment"
            ],
            sectionHeadings[reviewsSection]: [
                "Average Embr User Review: \(item.getAverageReviewString())",
                "Average Friend Review: \(item.getAverageFriendReviewString())"
            ],
            sectionHeadings[blurbSection]: [item.blurb!],
            sectionHeadings[moreSection]: item.childItems,
            sectionHeadings[commentsSection]: item.comments
        ]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reusableCellIdentifier = "cellId"
        var cell = itemDetailsTableView.dequeueReusableCellWithIdentifier(reusableCellIdentifier)
        
        let sectionTitle = sectionHeadings[indexPath.section]
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reusableCellIdentifier)
        }
        
        if let sectionDetail = itemDetails[sectionTitle]?[indexPath.row] {
            if sectionDetail is String {
                cell!.textLabel!.text = sectionDetail as? String
            } else if sectionDetail is Comment {
                cell!.textLabel!.text = (sectionDetail as! Comment).toString()
            } else if sectionDetail is MediaItem {
                cell!.textLabel!.text = (sectionDetail as! MediaItem).title
            }
            
            if indexPath.section == detailsSection {
                cell!.textLabel!.textAlignment = .Center
            } else {
                cell!.textLabel!.textAlignment = .Left
            }
            cell!.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
            cell!.textLabel!.numberOfLines = 0
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == commentsSection {
            performSegueWithIdentifier(commentsSegueIdentifier, sender: indexPath)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        assert(mediaItem != nil)
        if segue.identifier == commentsSegueIdentifier && sender is NSIndexPath {
            let destination = segue.destinationViewController as! CommentsViewController
            let indexPath = sender as! NSIndexPath
            destination.comments.removeAll()
            let selectedComment = mediaItem!.comments[indexPath.row]
            destination.comments.append(selectedComment)
            destination.comments.appendContentsOf(selectedComment.children)
        } else if segue.identifier == commentCreatorSegueIdentifier {
            if let destination = segue.destinationViewController as? CreateCommentViewController {
                destination.mediaItem = self.mediaItem!
            }
        } else if segue.identifier == librariesSegueIdentifier && sender is NSArray {
            let destination = segue.destinationViewController as! LibrariesListTableViewController
            let libraries = parseLibraryList(librariesArray: sender as! NSArray)
            destination.librariesList = libraries
        } else if segue.identifier == moreInfoSegueIdentifier {
            if let destination = segue.destinationViewController as? ItemMoreInfoTableViewController {
                destination.mediaItem = self.mediaItem!
            } else {
                printError(errorHeader, errorMessage: "More Info destination invalid")
            }
        }
    }
    
    @IBAction func reviewItem(sender: UIButton) {
        if SessionModel.getSession() != SessionModel.noSession {
            let index = reviewCollection.indexOf(sender)
            for i in 0...4 {
                let star = reviewCollection[i]
                if i <= index {
                    star.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
                } else {
                    star.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                }
            }
            
            ItemDataSource.updateItemReview(self.mediaItem!, review: (index! + 1), completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if data != nil {
                    let message = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                    print(message)
                }
            })
        } else {
            promptUserLogin()
        }
    }
    
    @IBAction func attemptAddToLibrary(sender: UIButton) {
        if SessionModel.getSession() != SessionModel.noSession {
            addToLibrary()
        } else {
            promptUserLogin()
        }
    }
    
    
    func addToLibrary() {
        UserDataSource.getUserId { (data, response, error) -> Void in
            if data != nil {
                do {
                    if let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                        if jsonResponse["success"] as! Bool {
                            let userId = jsonResponse["response"] as! Int
                            LibrariesDataSource.getMyLibraries(userId, completionHandler: { (data, response, error) -> Void in
                                if data != nil {
                                    let libraryActionSheet = UIAlertController(title: "Add to Library", message: nil, preferredStyle: .ActionSheet)
                                    do {
                                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                                        if jsonResponse["success"] as! Bool {
                                            if let response = jsonResponse["response"] as? NSArray {
                                                let librariesList = parseLibraryList(librariesArray: response)
                                                for library in librariesList {
                                                    libraryActionSheet.addAction(UIAlertAction(title: library.name, style: .Default, handler: { action in
                                                        let libraryId = library.id
                                                        LibrariesDataSource.addItemToLibrary(libraryId, itemId: self.mediaItem!.id, completionHandler: {data, response, error in /* Do nothing */ })
                                                    }))
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
                                    dispatch_async(dispatch_get_main_queue()) {
                                        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                                        libraryActionSheet.addAction(cancelAction)
                                        self.presentViewController(libraryActionSheet, animated: true, completion: nil)
                                    }
                                }
                            })
                        }
                    }
                } catch {
                    let errorMsg = "Invalid data from GetUserIdFromSession.py"
                    print(errorMsg)
                }
            }
        }
    }
    
    @IBAction func commentOnItem(sender: UIButton) {
        if SessionModel.getSession() != SessionModel.noSession {
            performSegueWithIdentifier(commentCreatorSegueIdentifier, sender: nil)
        } else {
            promptUserLogin()
        }
    }
    
    func attemptToOpenLibraries() {
        if SessionModel.getSession() != SessionModel.noSession {
            goToLibraries()
        } else {
            promptUserLogin()
        }
    }
    
    func goToLibraries() {
        UserDataSource.getUserId { (data, response, error) -> Void in
            if data != nil {
                do {
                    if let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                        if jsonResponse["success"] as! Bool {
                            let userId = jsonResponse["response"] as! Int
                            LibrariesDataSource.getMyLibraries(userId, completionHandler: { (data, response, error) -> Void in
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
                    }
                } catch {
                    let errorMsg = "Invalid data from GetUserIdFromSession.py"
                    print(errorMsg)
                }
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
    
    private func promptUserLogin() {
        let alert = UIAlertController(title: "Login", message: "Login required to access this content.", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({(textfield: UITextField) in textfield.placeholder = "Username"})
        alert.addTextFieldWithConfigurationHandler({(textfield: UITextField) in
            textfield.secureTextEntry = true
            textfield.placeholder = "Password"
        })
        let loginAction = UIAlertAction(title: "Login", style: .Default, handler: {(action: UIAlertAction) in
            if let username = alert.textFields![0].text, password = alert.textFields![1].text {
                UserDataSource.attemptLogin(username, password: password, completionHandler: self.loginCompletionHandler)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(loginAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeadings[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionHeadings.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionHeadings[section]
        let sectionDetails = itemDetails[sectionTitle]
        return sectionDetails?.count ?? 0
    }
}
