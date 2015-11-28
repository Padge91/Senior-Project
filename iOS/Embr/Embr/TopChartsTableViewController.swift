import UIKit

class TopChartsTableViewController: UITableViewController {
    
    private let errorHeader = "Top Charts Table View Controller"
    private let itemDetailsSegueIdentifier = "segueToItemDetails"
    var charts = [String: [MediaItem]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        TopChartsModel.getTopCharts { (data, response, error) -> Void in
            if data != nil {
                do {
                    let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    if jsonResponse["success"] as! Bool {
                        if let chartsResponse = jsonResponse["response"] as? NSArray {
                            for chart in chartsResponse {
                                let name = chart["name"] as! String
                                let objects = chart["objects"] as! [NSDictionary]
                                for object in objects {
                                    let mediaItem = MediaItem(mediaItemDictionary: object)
                                    if self.charts[name] != nil {
                                        self.charts[name]!.append(mediaItem)
                                    } else {
                                        self.charts[name] = [mediaItem]
                                    }
                                }
                            }
                        }
                        print(self.charts)
                        for key in self.charts.keys {
                            print(key + " \(self.charts[key]!.count)")
                        }
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                        }
                    } else {
                        print(jsonResponse["response"])
                    }
                } catch {}
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case itemDetailsSegueIdentifier:
            if let item = sender as? MediaItem {
                if let destination = segue.destinationViewController as? ItemDetailsViewController {
                    destination.setMediaItem(item)
                }
            }
        default:
            break
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.charts.keys.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let title = Array(self.charts.keys)[section]
        let count = self.charts[title]!.count
        return count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(self.charts.keys)[section]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let title = Array(self.charts.keys)[indexPath.section]
        if let chart = charts[title] {
            let item = chart[indexPath.row]
            ItemDataSource.getItem(item.id, completionHandler: self.getItemCompletionHandler)
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
                                self.performSegueWithIdentifier(self.itemDetailsSegueIdentifier, sender: itemToView)
                            }
                        }
                    }
                }
            } catch {}
        } else {
            printError(errorHeader, errorMessage: "getItemCompletionHandler: no data")
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let sectionTitle = Array(self.charts.keys)[indexPath.section]
        cell!.textLabel!.text = charts[sectionTitle]![indexPath.row].title
        
        return cell!
    }

}
