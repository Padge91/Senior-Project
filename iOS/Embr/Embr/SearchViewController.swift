import UIKit

class SearchViewController : UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    
    private let errorHeader = "Search View Controller Error:\n"
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
    
    func goToMenu() {
        performSegueWithIdentifier(menuSegueIdentifier, sender: nil)
    }
    
    func attemptToOpenProfile() {
        if SessionModel.getSession() != SessionModel.noSession {
            goToProfile()
        } else {
            displayLoginAlert(self, completionHandler: loginCompletionHandler)
        }
    }
    
    func attemptToOpenLibraries() {
        if SessionModel.getSession() != SessionModel.noSession {
            goToLibraries()
        } else {
            displayLoginAlert(self, completionHandler: loginCompletionHandler)
        }
    }
    
    func openTopCharts() {
        performSegueWithIdentifier(topChartsSegueIdentifier, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier {
            switch id {
            case itemDetailSegueIdentifier:
                if let destination = segue.destinationViewController as? ItemDetailsViewController {
                    if let mediaItem = sender as? MediaItem {
                        destination.setMediaItem(mediaItem)
                    } else {
                        printError(errorHeader, errorMessage: "Item detail sender invalid")
                    }
                } else {
                    printError(errorHeader, errorMessage: "Item detail destination invalid")
                }
            case librariesSegueIdentifier:
                if let destination = segue.destinationViewController as? LibrariesListTableViewController {
                    if let librariesArray = sender as? NSArray {
                        let libraries = parseLibraryList(librariesArray: librariesArray)
                        destination.librariesList = libraries
                    } else {
                        printError(errorHeader, errorMessage: "Libraries sender invalid")
                    }
                } else {
                    printError(errorHeader, errorMessage: "Libraries destination invalid")
                }
            case profileSegueIdentifier:
                if let user = sender as? User {
                    if let destination = segue.destinationViewController as? ProfileViewController {
                        destination.user = user
                    } else {
                        printError(errorHeader, errorMessage: "Profile destination invalid")
                    }
                } else {
                    printError(errorHeader, errorMessage: "Profile sender invalid")
                }
            default:
                break
            }
        } else {
            printError(errorHeader, errorMessage: "Segue identifier is invalid")
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.searchResultsTableView.reloadData()
        if let searchCriteria = self.searchController.searchBar.text {
            ItemDataSource.getItemsBySearchCriteria(searchCriteria, completionHandler: getSearchResultsCompletionHandler)
        } else {
            printError(errorHeader, errorMessage: "Error: Search criteria is nil")
        }
    }
    
    func goToProfile() {
        UserDataSource.getUserId(getUserIdCompletionHandler)
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
        } else {
            printError(errorHeader, errorMessage: "getItemCompletionHandler: no data")
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
                    alertError(self, errorMessage: "Invalid login")
                }
            } catch {
                alertError(self, errorMessage: "Invalid response")
            }
        }
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
                                    newSearchResults.append(MediaItem(mediaItemDictionary: element as! NSDictionary))
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

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let mediaItem = searchResults[indexPath.row]
        cell!.textLabel!.text = mediaItem.title
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let itemToView = self.searchResults[indexPath.row]
        ItemDataSource.getItem(itemToView.id, completionHandler: self.getItemCompletionHandler)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
}
