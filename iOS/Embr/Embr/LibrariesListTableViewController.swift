import UIKit

class LibrariesListTableViewController: UITableViewController {

    let librarySegueIdentifier = "segueToLibrary"
    var librariesList = [Library]()
    var userId: Int?
    var isMe = false
    
    override func viewDidLoad() {
        assert(self.userId != nil)
        let userId = UserDataSource.getUserID()
        if userId == self.userId {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "createLibrary")
            self.isMe = true
        }
    }
    
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
        library.clearItems()
        LibrariesDataSource.getLibrary(library.id, completionHandler: {data, response, error in
            if data != nil {
                do {
                    let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    if jsonResponse["success"] as! Bool {
                        if let libraryItemsArray = jsonResponse["response"] as? [NSDictionary] {
                            for element in libraryItemsArray {
                                let mediaItem = MediaItem(mediaItemDictionary: element)
                                library.addItemToLibrary(mediaItem)
                            }
                            dispatch_async(dispatch_get_main_queue()) {
                                self.performSegueWithIdentifier(self.librarySegueIdentifier, sender: library)
                            }
                        } else {
                            print("Invalid response from GetLibraryItems.py\nResponse not NSArray")
                        }
                    } else {
                        let error = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("Invalid response from GetLibraryItems.py\n\(error!)")
                    }
                } catch {
                    print("Invalid response from GetLibraryItems.py")
                }
            } else {
                print("No data from GetLibraryItems.py")
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == librarySegueIdentifier && sender is Library {
            if let destination = segue.destinationViewController as? LibraryViewController {
                if let lib = sender as? Library {
                    destination.library = lib
                    destination.userId = self.userId
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return UserDataSource.getUserID() == self.userId
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if isMe {
            if editingStyle == UITableViewCellEditingStyle.Delete {
                let lib = librariesList[indexPath.row]
                librariesList.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                LibrariesDataSource.deleteLibrary(lib.id, completionHandler: { (data, response, error) -> Void in
                    /* Do Nothing */
                })
            }
        }
    }
    
    func createLibrary() {
        let alert = UIAlertController(title: "Create New Library", message: "", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({(textfield: UITextField) in textfield.placeholder = "Custom Library Name"})
        let createAction = UIAlertAction(title: "Create", style: .Default, handler: {(action: UIAlertAction) in
            if let libraryName = alert.textFields![0].text {
                LibrariesDataSource.createLibrary(libraryName, completionHandler: { (data, response, error) -> Void in
                    if data != nil {
                        do {
                            let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                            if jsonResponse["success"] as! Bool {
                                print("\(jsonResponse["response"])")
                            }
                        } catch {}
                    }
                })
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }

}
