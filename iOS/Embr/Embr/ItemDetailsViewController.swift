import UIKit

class ItemDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let commentsSegueIdentifier = "commentsSegue"
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
    }
    
    private func setupItemDetailsTable() {
        itemDetailsTableView.dataSource = self
        itemDetailsTableView.delegate = self
        itemDetailsTableView.estimatedRowHeight = 100.0
        itemDetailsTableView.rowHeight = UITableViewAutomaticDimension
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
        if sender is NSIndexPath && segue.identifier == commentsSegueIdentifier {
            let destination = segue.destinationViewController as! CommentsViewController
            let indexPath = sender as! NSIndexPath
            destination.comments.removeAll()
            let selectedComment = mediaItem!.comments[indexPath.row]
            destination.comments.append(selectedComment)
            destination.comments.appendContentsOf(selectedComment.children)
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
