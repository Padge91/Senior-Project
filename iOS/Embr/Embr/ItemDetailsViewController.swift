import UIKit

class ItemDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let librariesSegueIdentifier = "segueToLibraries"
    private let commentsSegueIdentifier = "segueToComments"
    private let commentCreatorSegueIdentifier = "segueToCommentCreator"
    private let menuSegueIdentifier = "segueToMenu"
    private let sectionHeadings = ["Reviews", "Blurb", "Comments"]
    private let reviewsSection = 0, blurbSection = 1, commentsSection = 2
    
    private var mediaItem: MediaItem? = nil
    private var itemDetails = [String: [AnyObject]]()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var topAttrubuteLabel: UILabel!
    @IBOutlet weak var bottomAttributeLabel: UILabel!
    @IBOutlet weak var itemDetailsTableView: UITableView!
    @IBOutlet var reviewCollection: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(mediaItem != nil)
        loadTitleAndImage()
        loadTopAttribute()
        loadBottomAttribute()
        setupItemDetailsTable()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: .Plain, target: self, action: "goToMenu")
        let librariesButton = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: "goToLibraries")
        toolbarItems = [librariesButton]
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
    
    private func loadTitleAndImage() {
        coverImageView.image = UIImage(named: mediaItem!.imageName!)
        titleLabel.text = mediaItem!.title
    }
    
    private func loadTopAttribute() {
        if mediaItem is Movie {
            topAttrubuteLabel.text = (mediaItem as! Movie).director
        } else if mediaItem is Book {
            topAttrubuteLabel.text = (mediaItem as! Book).author
        }
    }
    
    private func loadBottomAttribute() {
        assert(mediaItem != nil)
        if mediaItem is Movie {
            bottomAttributeLabel.text = (mediaItem as! Movie).cast.first
        } else if mediaItem is Book {
            bottomAttributeLabel.text = "Page Count: \((mediaItem as! Book).pageCount)"
        }
    }
    
    func setMediaItem(item: MediaItem) {
        mediaItem = item
        itemDetails = [
            sectionHeadings[reviewsSection]: [
                "Average Friend Reviews:",
                "Average Embr User Review:",
            ],
            sectionHeadings[blurbSection]: [item.blurb],
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
            }
            cell!.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
            cell!.textLabel!.numberOfLines = 0
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
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
            // Send media item
        }
    }
    
    @IBAction func reviewItem(sender: UIButton) {
        let index = reviewCollection.indexOf(sender)
        for i in 0...4 {
            let star = reviewCollection[i]
            if i <= index {
                star.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            } else {
                star.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            }
        }
    }
    
    @IBAction func addToLibrary(sender: UIButton) {
        let libraryActionSheet = UIAlertController(title: "Add to Library", message: nil, preferredStyle: .ActionSheet)
        let viewedAction = UIAlertAction(title: "Viewed", style: .Default, handler: nil)
        let ownedAction = UIAlertAction(title: "Owned", style: .Default, handler: nil)
        let wishlistAction = UIAlertAction(title: "Wishlist", style: .Default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        libraryActionSheet.addAction(viewedAction)
        libraryActionSheet.addAction(ownedAction)
        libraryActionSheet.addAction(wishlistAction)
        libraryActionSheet.addAction(cancelAction)
        presentViewController(libraryActionSheet, animated: true, completion: nil)
    }
    
    @IBAction func commentOnItem(sender: UIButton) {
        performSegueWithIdentifier(commentCreatorSegueIdentifier, sender: nil)
    }
    
    func goToLibraries() {
        if UserDataSource.getInstance().getSession() != nil {
            performSegueWithIdentifier(librariesSegueIdentifier, sender: nil)
        } else {
            let alert = UIAlertController(title: "Login", message: "Login to view your libraries:", preferredStyle: .Alert)
            alert.addTextFieldWithConfigurationHandler({(textfield: UITextField) in textfield.placeholder = "Username"})
            alert.addTextFieldWithConfigurationHandler({(textfield: UITextField) in
                textfield.secureTextEntry = true
                textfield.placeholder = "Password"
            })
            let loginAction = UIAlertAction(title: "Login", style: .Default, handler: {(action: UIAlertAction) in
                if let username = alert.textFields![0].text, password = alert.textFields![1].text {
                    UserDataSource.getInstance().attemptLogin(username, password: password, completionHandler: self.loginCompletionHandler)
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(loginAction)
            alert.addAction(cancelAction)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private func alertError(errorMessage error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private func succesfulLogin(sessionId session: String) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            UserDataSource.getInstance().storeSession(sessionId: session)
            self.performSegueWithIdentifier(self.librariesSegueIdentifier, sender: nil)
        }
    }
    
    func loginCompletionHandler (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void {
        if data != nil {
            do {
                let response = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                if let sessionResponse = response["success"], session = sessionResponse["session"] as? String {
                    succesfulLogin(sessionId: session)
                } else if response["error"] != nil {
                    alertError(errorMessage: "Invalid login")
                }
            } catch {
                alertError(errorMessage: "Invalid response")
            }
        }
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
