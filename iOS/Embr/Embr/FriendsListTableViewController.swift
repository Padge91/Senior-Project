import UIKit

class FriendsListTableViewController: UITableViewController {
    
    private let profileSegueIdentifier = "segueToProfile"
    
    var friends = [User]()
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(user != nil)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cellId"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        
        cell!.textLabel!.text = friends[indexPath.row].username
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let userId = UserDataSource.getUserID()
        return user!.id == userId
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { (rowAction: UITableViewRowAction, indexPath: NSIndexPath) -> Void in
            let friendToDelete = self.friends[indexPath.row]
            self.friends.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            UserDataSource.removeFriend(friendToDelete.id, completionHandler: { (data, response, error) -> Void in
                // Do Nothing
            })
        }
        return [deleteAction]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let friend = friends[indexPath.row]
        self.performSegueWithIdentifier(self.profileSegueIdentifier, sender: friend)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == profileSegueIdentifier && sender is User {
            let destination = segue.destinationViewController as! ProfileViewController
            destination.user = (sender as! User)
        }
    }

}
