import UIKit

class LibrariesListTableViewController: UITableViewController {

    let librarySegueIdentifier = "segueToLibrary"
    var librariesList = [Library]()
    var isMe = false
    
    override func viewDidLoad() {
        if isMe {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "createLibrary")
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
