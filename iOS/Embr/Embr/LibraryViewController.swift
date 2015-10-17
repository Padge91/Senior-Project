import UIKit

class LibraryViewController: UITableViewController {
    var library = [MediaItem]()
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cellId"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        
        let mediaItem = library[indexPath.row]
        cell!.textLabel!.text = mediaItem.title
        cell!.detailTextLabel?.text = mediaItem.creator
        if let imageName = mediaItem.imageName {
            cell!.imageView?.image = UIImage(named: imageName)
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return library.count
    }
}
