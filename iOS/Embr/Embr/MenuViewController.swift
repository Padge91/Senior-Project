import UIKit

class MenuViewController: UITableViewController {
    var menu = ["Login", "Logout", "Settings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cellId"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        
        cell!.textLabel!.text = menu[indexPath.row]
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
}