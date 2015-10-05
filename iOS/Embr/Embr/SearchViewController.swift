import UIKit

class SearchViewController : UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    
    private let itemDetailSegueIdentifier = "segueToItemDetails"
    private let menuSegueIdentifier = "segueToMenu"
    private var model = ItemDataSource.getInstance()
    private var searchResults = [MediaItem]()
    private var searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupSearchResultsTableView()
        definesPresentationContext = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: .Plain, target: self, action: "goToMenu")
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
        searchResults = model.getItemsBySearchCriteria(self.searchController.searchBar.text!)
        searchResultsTableView.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
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
