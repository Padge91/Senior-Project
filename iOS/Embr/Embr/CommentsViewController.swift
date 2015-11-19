import UIKit

class CommentsViewController: UITableViewController {
    let menuSegueIdentifier = "segueToMenu"
    let profileSegueIdentifier = "segueToProfile"
    let createCommentSegueIdentifier = "segueToAddComment"
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: .Plain, target: self, action: "goToMenu")
    }
    
    func goToMenu() {
        performSegueWithIdentifier(menuSegueIdentifier, sender: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cellId"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        
        cell!.textLabel!.text = comments[indexPath.row].toString()
        cell!.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell!.textLabel!.numberOfLines = 0
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let moreAction = UITableViewRowAction(style: .Normal, title: "More") { (rowAction: UITableViewRowAction, indexPath: NSIndexPath) -> Void in
            let moreAction = UIAlertController(title: "Options", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            let viewUserAction = UIAlertAction(title: "View User Profile", style: .Default, handler: { (action: UIAlertAction) -> Void in
                let comment = self.comments[indexPath.row]
                self.performSegueWithIdentifier(self.profileSegueIdentifier, sender: comment.author)
            })
            if SessionModel.getSession() != SessionModel.noSession {
                let replyAction = UIAlertAction(title: "Reply", style: .Default, handler: { (action: UIAlertAction) -> Void in
                    let comment = self.comments[indexPath.row]
                    self.performSegueWithIdentifier(self.createCommentSegueIdentifier, sender: comment)
                })
                moreAction.addAction(replyAction)
            } else {
                moreAction.message = "Log in to reply to comments"
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            moreAction.addAction(viewUserAction)
            moreAction.addAction(cancelAction)
            self.presentViewController(moreAction, animated: true, completion: nil)
        }
        
        return [moreAction]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == profileSegueIdentifier {
            let destination = segue.destinationViewController as! ProfileViewController
            if let user = sender as? User? {
                destination.user = user
            }
        } else if segue.identifier == createCommentSegueIdentifier && sender is Comment {
            let destination = segue.destinationViewController as! CreateCommentViewController
            destination.parentComment = sender as? Comment
        }
    }
    
}
