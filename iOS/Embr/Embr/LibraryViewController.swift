import UIKit

class LibraryViewController: UITableViewController {
    private let itemDetailSegueIdentifier = "segueToItemDetails"
    var library: Library?
    var userId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(userId != nil)
        self.tableView.allowsMultipleSelectionDuringEditing = false        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let item = library!.items[indexPath.row]
            library!.removeItemAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            LibrariesDataSource.deleteItemFromLibrary(library!.id, itemId: item.id, completionHandler: { (data, response, error) -> Void in
                /* Do Nothing */
            })
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return UserDataSource.getUserID() == self.userId
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cellId"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        
        let mediaItem = library?.items[indexPath.row]
        cell!.textLabel!.text = mediaItem!.title
        //cell!.detailTextLabel?.text = mediaItem.creator
        if let imageName = mediaItem!.imageName {
            if let imageURL = NSURL(string: imageName) {
                if let imageData = NSData(contentsOfURL: imageURL) {
                    cell!.imageView?.image = UIImage(data: imageData)
                }
            }
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return library!.items.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let itemToView = self.library!.items[indexPath.row]
        ItemDataSource.getItem(itemToView.id, completionHandler: self.getItemCompletionHandler)
    }
    
    func getItemCompletionHandler(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void {
        if data != nil {
            do {
                if let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary {
                    if jsonResponse["success"] as! Bool {
                        if let response = jsonResponse["response"] as? NSDictionary {
                            dispatch_async(dispatch_get_main_queue()) {
                                let itemToView = parseMediaItem(response)
                                self.performSegueWithIdentifier(self.itemDetailSegueIdentifier, sender: itemToView)
                            }
                        }
                    }
                }
            } catch {}
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender is MediaItem && segue.identifier == itemDetailSegueIdentifier {
            let destination = segue.destinationViewController as! ItemDetailsViewController
            destination.setMediaItem(sender as! MediaItem)
        }
    }
}
