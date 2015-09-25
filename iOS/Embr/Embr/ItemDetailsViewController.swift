//
//  ItemDetailsViewController.swift
//  Embr
//
//  Created by Alex Ronquillo on 9/16/15.
//  Copyright (c) 2015 SeniorProject. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let model = ItemDetailModel.getModel()
    private var mediaItem: MediaItem? = nil
    var itemDetails = [String: [AnyObject]]()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var topAttrubuteLabel: UILabel!
    @IBOutlet weak var bottomAttributeLabel: UILabel!
    @IBOutlet weak var itemDetailsTableView: UITableView!
    @IBOutlet var reviewCollection: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTitleAndImage()
        loadTopAttribute()
        loadBottomAttribute()
        setupItemDetailsTable()
    }
    
    func setupItemDetailsTable() {
        itemDetailsTableView.dataSource = self
        itemDetailsTableView.delegate = self
        itemDetailsTableView.estimatedRowHeight = 100.0
        itemDetailsTableView.rowHeight = UITableViewAutomaticDimension
        itemDetailsTableView.backgroundColor = UIColor.whiteColor()
    }
    
    func loadTitleAndImage() {
        assert(mediaItem != nil)
        coverImageView.image = UIImage(named: mediaItem!.imageName!)
        titleLabel.text = mediaItem!.title
    }
    
    func loadTopAttribute() {
        assert(mediaItem != nil)
        if mediaItem is Movie {
            topAttrubuteLabel.text = (mediaItem as! Movie).director
        } else if mediaItem is Book {
            topAttrubuteLabel.text = (mediaItem as! Book).author
        }
    }
    
    func loadBottomAttribute() {
        assert(mediaItem != nil)
        if mediaItem is Movie {
            bottomAttributeLabel.text = (mediaItem as! Movie).cast[0]
        } else if mediaItem is Book {
            bottomAttributeLabel.text = "Page Count: \((mediaItem as! Book).pageCount)"
        }
    }
    
    func setMediaItem(item: MediaItem) {
        mediaItem = item
        itemDetails = [
            model.itemDetailHeadings[0]: [
                "Average Friend Reviews:",
                "Average Embr User Review:",
            ],
            model.itemDetailHeadings[1]: [item.blurb],
            model.itemDetailHeadings[2]: item.comments
        ]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reusableCellIdentifier = "cellId"
        var cell = itemDetailsTableView.dequeueReusableCellWithIdentifier(reusableCellIdentifier)
        
        let sectionTitle = model.itemDetailHeadings[indexPath.section]
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reusableCellIdentifier)
        }
        
        if let sectionDetail = itemDetails[sectionTitle]?[indexPath.row] {
            if sectionDetail is String {
                cell!.textLabel!.text = sectionDetail as? String
            } else if sectionDetail is Comment {
                cell!.textLabel!.text = (sectionDetail as! Comment).toString()
            }
            cell!.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
            cell!.textLabel!.numberOfLines = 0
        }
        
        return cell!
    }
    
    @IBAction func reviewItem(sender: UIButton) {
        let index = reviewCollection.indexOf(sender)
        for i in 0...4 {
            let star = reviewCollection[i]
            if i <= index {
                star.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            } else {
                star.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            }
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.itemDetailHeadings[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.itemDetailHeadings.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = model.itemDetailHeadings[section]
        let sectionDetails = itemDetails[sectionTitle]
        return sectionDetails?.count ?? 0
    }
}
