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
    @IBOutlet weak var topAttributeLabel: UILabel!
    @IBOutlet weak var bottomAttributeLabel: UILabel!
    @IBOutlet weak var itemDetailsTableView: UITableView!
    @IBOutlet var reviewCollection: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(mediaItem != nil)
        print(mediaItem!.myReview)
        loadTitle()
        loadImage()
        loadTopAttribute()
        loadBottomAttribute()
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
        let librariesItem = UIBarButtonItem(title: "My Libraries", style: .Plain, target: self, action: "goToLibraries")
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
    
    private func loadTopAttribute() {
        assert(mediaItem != nil)
        topAttributeLabel.text = mediaItem!.creator
    }
    
    private func loadBottomAttribute() {
        assert(mediaItem != nil)
        if mediaItem is Movie {
            bottomAttributeLabel.text = (mediaItem as! Movie).cast.first
        } else if mediaItem is Book {
            bottomAttributeLabel.text = "Page Count: \((mediaItem as! Book).pageCount)"
        } else {
            bottomAttributeLabel.hidden = true
        }
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
            sectionHeadings[reviewsSection]: [
                "Average Embr User Review: \(mediaItem!.getAverageReviewString())",
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
            if let destination = segue.destinationViewController as? CreateCommentViewController {
                destination.mediaItem = self.mediaItem!
            }
        }
    }
    
    @IBAction func reviewItem(sender: UIButton) {
        if SessionModel.getSession() != SessionModel.noSession {
            // Update UI
            let index = reviewCollection.indexOf(sender)
            for i in 0...4 {
                let star = reviewCollection[i]
                if i <= index {
                    star.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
                } else {
                    star.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                }
            }
            
            // Update DB
            ItemDataSource.updateItemReview(self.mediaItem!, review: (index! + 1), completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in /* Do nothing */})
        } else {
            promptUserLogin()
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
        if SessionModel.getSession() != SessionModel.noSession {
            performSegueWithIdentifier(librariesSegueIdentifier, sender: nil)
        } else {
            promptUserLogin()
        }
    }
    
    private func promptUserLogin() {
        let alert = UIAlertController(title: "Login", message: "Login required to access this content.", preferredStyle: .Alert)
        let loginAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
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
