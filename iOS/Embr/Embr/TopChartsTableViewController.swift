//
//  TopChartsTableViewController.swift
//  Embr
//
//  Created by Alex Ronquillo on 11/16/15.
//  Copyright © 2015 SeniorProject. All rights reserved.
//

import UIKit

class TopChartsTableViewController: UITableViewController {
    
    var charts = [String: [GenericMediaItem]]()

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
                                let objects = chart["objects"] as! NSArray
                                for object in objects {
                                    let mediaItem = GenericMediaItem(mediaItemDictionary: object as! NSDictionary)
                                    var chart = self.charts[name]
                                    if chart == nil {
                                        self.charts[name] = [mediaItem]
                                    } else {
                                        chart!.append(mediaItem)
                                    }
                                }
                            }
                        }
                        print(self.charts)
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.charts.keys.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let title = Array(self.charts.keys)[section]
        return self.charts[title]!.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(self.charts.keys)[section]
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
