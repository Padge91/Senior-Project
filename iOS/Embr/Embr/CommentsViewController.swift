import UIKit

class CommentsViewController: UITableViewController {
    let menuSegueIdentifier = "segueToMenu"
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
}
