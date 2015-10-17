import UIKit

class LibrariesListTableViewController: UITableViewController {

    let librarySegueIdentifier = "segueToLibrary"
    var librariesList = [Library]()
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cellId"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        
        cell!.textLabel!.text = librariesList[indexPath.row].name
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return librariesList.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let library = librariesList[indexPath.row]
        LibrariesDataSource.getLibrary(library.id, completionHandler: {data, response, error in
            if data != nil {
                do {
                    let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    if jsonResponse["success"] as! Bool {
                        if let libraryItemsArray = jsonResponse["response"] as? NSArray {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.performSegueWithIdentifier(self.librarySegueIdentifier, sender: libraryItemsArray)
                            }
                        } else {
                            log(logType: EmbrLogType.Error, message: "Invalid response from GetLibraryItems.py\nResponse not NSArray")
                        }
                    } else {
                        let error = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        log(logType: EmbrLogType.Error, message: "Invalid response from GetLibraryItems.py\n\(error!)")
                    }
                } catch {
                    log(logType: EmbrLogType.Error, message: "Invalid response from GetLibraryItems.py")
                }
            } else {
                log(logType: EmbrLogType.Error, message: "No data from GetLibraryItems.py")
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == librarySegueIdentifier && sender is NSArray {
            let destination = segue.destinationViewController as! LibraryViewController
            var library = [MediaItem]()
            for element in sender as! NSArray {
                let mediaItem = GenericMediaItem.parseGenericMediaItem(element as! NSDictionary)
                library.append(mediaItem)
            }
            destination.library = library
        }
    }

}
