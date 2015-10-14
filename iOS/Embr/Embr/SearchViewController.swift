import UIKit

class SearchViewController : UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    
    private let itemDetailSegueIdentifier = "segueToItemDetails"
    private let menuSegueIdentifier = "segueToMenu"
    private let librariesSegueIdentifier = "segueToLibraries"
    private var model = ItemDataSource.getInstance()
    private var searchResults = [MediaItem]()
    private var searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupSearchResultsTableView()
        definesPresentationContext = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: .Plain, target: self, action: "goToMenu")
        let librariesButton = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: "goToLibraries")
        toolbarItems = [librariesButton]
    }
    
    func goToMenu() {
        performSegueWithIdentifier(menuSegueIdentifier, sender: nil)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
    }
    
    private func setupSearchResultsTableView() {
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.tableHeaderView = searchController.searchBar
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(itemDetailSegueIdentifier, sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender is NSIndexPath && segue.identifier == itemDetailSegueIdentifier {
            let destination = segue.destinationViewController as! ItemDetailsViewController
            let mediaItem = searchResults[(sender as! NSIndexPath).row]
            destination.setMediaItem(mediaItem)
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.searchResults = []
        self.searchResultsTableView.reloadData()
        model.getItemsBySearchCriteria(self.searchController.searchBar.text!, completionHandler: getSearchResultsCompletionHandler)
    }
    
    func getSearchResultsCompletionHandler (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void {
        if data != nil {
            do {
                if let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary {
                    if responseObject["success"] as! Bool {
                        if let successArray = responseObject["response"] as? NSArray {
                            for element in successArray {
                                if element is NSDictionary {
                                    self.searchResults.append(BasicMediaItem.parseBasicMediaItem(element as! NSDictionary))
                                }
                            }
                        }
                    }
                }
            } catch {}
            if self.searchResults.count > 0 {
                dispatch_async(dispatch_get_main_queue()) {
                    self.searchResultsTableView.reloadData()
                }
            }
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let mediaItem = searchResults[indexPath.row]
        cell!.textLabel!.text = mediaItem.title
        
        if mediaItem is Book {
            cell!.detailTextLabel?.text = (mediaItem as! Book).author
        } else if mediaItem is Movie {
            cell!.detailTextLabel?.text = (mediaItem as! Movie).director
        }
        
        if let imageName = mediaItem.imageName {
            cell!.imageView?.image = UIImage(named: imageName)
        }
        
        return cell!
    }
    
}
