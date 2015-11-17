import UIKit

class SearchViewController : UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    
    private let itemDetailSegueIdentifier = "segueToItemDetails"
    private let menuSegueIdentifier = "segueToMenu"
    private let librariesSegueIdentifier = "segueToLibraries"
    private let profileSegueIdentifier = "segueToProfile"
    private let topChartsSegueIdentifier = "segueToTopCharts"
    private var searchResults = [MediaItem]()
    private var searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupSearchResultsTableView()
        definesPresentationContext = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: .Plain, target: self, action: "goToMenu")
        let librariesButton = UIBarButtonItem(title: "My Libraries", style: .Plain, target: self, action: "attemptToOpenLibraries")
        let profileButton = UIBarButtonItem(title: "Profile", style: .Plain, target: self, action: "attemptToOpenProfile")
        let topChartsButton = UIBarButtonItem(title: "Top Charts", style: .Plain, target: self, action: "openTopCharts")
        toolbarItems = [librariesButton, profileButton, topChartsButton]
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
        let itemToView = self.searchResults[indexPath.row]
        ItemDataSource.getItem(SessionModel.getSession(), id: itemToView.id, completionHandler: self.getItemCompletionHandler)
    }
    
    func getItemCompletionHandler(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void {
        if data != nil {
            do {
                if let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary {
                    if jsonResponse["success"] as! Bool {
                        if let response = jsonResponse["response"] as? NSDictionary {
                            dispatch_async(dispatch_get_main_queue()) {
                                let itemToView = GenericMediaItem.parseGenericMediaItem(response)
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
        } else if segue.identifier == librariesSegueIdentifier && sender is NSArray {
            let destination = segue.destinationViewController as! LibrariesListTableViewController
            let libraries = parseLibraryList(librariesArray: sender as! NSArray)
            destination.librariesList = libraries
        } else if segue.identifier == profileSegueIdentifier && sender is User {
            let user = sender as! User
            if let destination = segue.destinationViewController as? ProfileViewController {
                destination.user = user
            }
        }
    }
    
    func openTopCharts() {
        performSegueWithIdentifier(topChartsSegueIdentifier, sender: nil)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.searchResultsTableView.reloadData()
        ItemDataSource.getItemsBySearchCriteria(self.searchController.searchBar.text!, completionHandler: getSearchResultsCompletionHandler)
    }
    
    func getSearchResultsCompletionHandler (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void {
        var newSearchResults = [MediaItem]()
        if data != nil {
            do {
                if let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary {
                    if responseObject["success"] as! Bool {
                        if let successArray = responseObject["response"] as? NSArray {
                            for element in successArray {
                                if element is NSDictionary {
                                    newSearchResults.append(GenericMediaItem.parseGenericMediaItem(element as! NSDictionary))
                                }
                            }
                        }
                    }
                }
            } catch {}
            if newSearchResults.count > 0 {
                dispatch_async(dispatch_get_main_queue()) {
                    self.searchResults = newSearchResults
                    self.searchResultsTableView.reloadData()
                }
            }
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func goToLibraries() {
        UserDataSource.getUserId { (data, response, error) -> Void in
            if data != nil {
                do {
                    if let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                        if jsonResponse["success"] as! Bool {
                            let userId = jsonResponse["response"] as! Int
                            LibrariesDataSource.getMyLibraries(userId, completionHandler: { (data, response, error) -> Void in
                                if data != nil {
                                    do {
                                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                                        if jsonResponse["success"] as! Bool {
                                            if let response = jsonResponse["response"] as? NSArray {
                                                if response.count > 0 {
                                                    dispatch_async(dispatch_get_main_queue()) {
                                                        self.performSegueWithIdentifier(self.librariesSegueIdentifier, sender: response)
                                                    }
                                                }
                                            } else {
                                                let jsonError = jsonResponse["response"]
                                                let errorMsg = "Invalid response from GetLibrariesList.py:\n\(jsonError)"
                                                print(errorMsg)
                                            }
                                        } else {
                                            let jsonError = jsonResponse["response"]
                                            let errorMsg = "Invalid response from GetLibrariesList.py:\n\(jsonError)"
                                            print(errorMsg)
                                        }
                                    } catch {
                                        let errorMsg = "Invalid data from GetLibrariesList.py"
                                        print(errorMsg)
                                    }
                                }
                            })
                        }
                    }
                } catch {
                    let errorMsg = "Invalid data from GetUserIdFromSession.py"
                    print(errorMsg)
                }
            }
        }
    }
    
    func displayLoginAlert() {
        let alert = UIAlertController(title: "Login", message: "Login to view your libraries:", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({(textfield: UITextField) in textfield.placeholder = "Username"})
        alert.addTextFieldWithConfigurationHandler({(textfield: UITextField) in
            textfield.secureTextEntry = true
            textfield.placeholder = "Password"
        })
        let loginAction = UIAlertAction(title: "Login", style: .Default, handler: {(action: UIAlertAction) in
            if let username = alert.textFields![0].text, password = alert.textFields![1].text {
                UserDataSource.attemptLogin(username, password: password, completionHandler: self.loginCompletionHandler)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(loginAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func goToProfile() {
        UserDataSource.getUserId(getUserIdCompletionHandler)
    }
    
    func getUserIdCompletionHandler (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void {
        if data != nil {
            do {
                let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                if jsonResponse["success"] as! Bool {
                    if let userId = jsonResponse["response"] as? Int {
                        UserDataSource.getUser(userId, completionHandler: { (data, response, error) -> Void in
                            if data != nil {
                                do {
                                    let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                                    if jsonResponse["success"] as! Bool {
                                        if let userDict = jsonResponse["response"] as? NSDictionary {
                                            let user = User.parseUser(userDict)
                                            dispatch_async(dispatch_get_main_queue()) {
                                                self.performSegueWithIdentifier(self.profileSegueIdentifier, sender: user)
                                            }
                                        }
                                    }
                                } catch {}
                            }
                        })
                    }
                }
            } catch {}
        }
    }

    
    func attemptToOpenProfile() {
        if SessionModel.getSession() != SessionModel.noSession {
            goToProfile()
        } else {
            displayLoginAlert()
        }
    }
    
    func attemptToOpenLibraries() {
        if SessionModel.getSession() != SessionModel.noSession {
            goToLibraries()
        } else {
            displayLoginAlert()
        }
    }
    
    private func alertError(errorMessage error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        dispatch_async(dispatch_get_main_queue()){
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private func succesfulLogin(sessionId session: String) {
        dispatch_async(dispatch_get_main_queue()) {
            SessionModel.storeSession(sessionId: session)
        }
    }
    
    func loginCompletionHandler (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void {
        if data != nil {
            do {
                let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                if jsonResponse["success"] as! Bool {
                    if let session = jsonResponse["response"] as? String {
                        succesfulLogin(sessionId: session)
                    }
                } else if jsonResponse["response"] != nil {
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
        cell!.detailTextLabel?.text = mediaItem.creator
        
        return cell!
    }
    
}
