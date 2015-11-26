//
//  ItemMoreInfoTableViewController.swift
//  Embr
//
//  Created by Alex Ronquillo on 11/21/15.
//  Copyright © 2015 SeniorProject. All rights reserved.
//

import UIKit

class ItemMoreInfoTableViewController: UITableViewController {
    
    var mediaItem: MediaItem?
    var headers = [String]()
    var itemInfo = [String: [AnyObject]]()
    private let basicHeader = 0, specialHeader = 1, genresHeader = 2, moreHeader = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(mediaItem != nil)
        headers.append("Basic Information")
        addSpecialHeader()
        headers.append("Genres")
        headers.append("More")
        setupItemInfo()
        self.tableView.estimatedRowHeight = 100.0
    }
    
    private func addSpecialHeader() {
        if self.mediaItem is Movie {
            self.headers.append("Movie Information")
        } else if self.mediaItem is Book {
            self.headers.append("Book Information")
        } else if self.mediaItem is Game {
            self.headers.append("Video Game Information")
        } else if self.mediaItem is TelevisionShow {
            self.headers.append("Television Show Information")
        } else if self.mediaItem is Music {
            self.headers.append("Music Information")
        }
    }
    
    private func setupItemInfo() {
        // Setup basic information
        self.itemInfo[self.headers[basicHeader]] = [
            self.mediaItem!.title!,
            self.mediaItem!.blurb!
        ]
        
        // Setup type specific information
        self.itemInfo[headers[specialHeader]] = []
        if self.mediaItem is Movie {
            let movie = self.mediaItem as! Movie
            self.itemInfo[headers[specialHeader]]?.append("Director: \(movie.director!)")
            self.itemInfo[headers[specialHeader]]?.append("Writer: \(movie.writer!)")
			self.itemInfo[headers[specialHeader]]?.append("Studio: \(movie.studio!)")
			self.itemInfo[headers[specialHeader]]?.append("Cast: \(movie.cast!)")
			self.itemInfo[headers[specialHeader]]?.append("Rating: \(movie.rating!)")
			if movie.releaseDate != nil {
				self.itemInfo[headers[specialHeader]]?.append("Release Date: \(movie.releaseDate!)")
			}
			if movie.runtime != nil {
				self.itemInfo[headers[specialHeader]]?.append("Runtime: \(movie.runtime!)")
			}
        } else if self.mediaItem is Book {
            let book = self.mediaItem as! Book
            self.itemInfo[headers[specialHeader]]?.append("Author(s): \(book.authors!)")
            self.itemInfo[headers[specialHeader]]?.append("Publisher: \(book.publisher)")
            self.itemInfo[headers[specialHeader]]?.append("Publish Date: \(book.publishDate)")
            self.itemInfo[headers[specialHeader]]?.append("Edition: \(book.edition!)")
            self.itemInfo[headers[specialHeader]]?.append("Page Count: \(book.numPages!)")
        } else if self.mediaItem is Game {
            let game = self.mediaItem as! Game
            self.itemInfo[headers[specialHeader]]?.append("Studio: \(game.studio!)")
            self.itemInfo[headers[specialHeader]]?.append("Publisher: \(game.publisher!)")
            self.itemInfo[headers[specialHeader]]?.append("Rating: \(game.rating ?? "NA")")
            self.itemInfo[headers[specialHeader]]?.append("Multiplayer: \(game.multiplayer ? "✔︎":"✗")")
            self.itemInfo[headers[specialHeader]]?.append("Singleplayer: \(game.singleplayer ? "✔︎":"✗")")
            self.itemInfo[headers[specialHeader]]?.append("Release Date: \(game.releaseDate!)")
            self.itemInfo[headers[specialHeader]]?.append("Game Length: \(game.length!)")
        } else if self.mediaItem is TelevisionShow {
            let show = self.mediaItem as! TelevisionShow
            self.itemInfo[headers[specialHeader]] = [
                "Director: \(show.director!)",
                "Writer: \(show.writer!)",
                "Cast: \(show.cast!)",
                "Channel: \(show.channel!)",
                "Rating: \(show.rating!)",
                "Air Date: \(show.airDate!)",
                "Runtime: \(show.runtime!)"
            ]
        } else if self.mediaItem is Music {
            let music = self.mediaItem as! Music
            self.itemInfo[headers[specialHeader]] = [
                "Artist: \(music.artist!)",
                "Recording Company: \(music.recordingCompany!)",
                "Length: \(music.length!)",
                "Release Date: \(music.releaseDate)"
            ]
        }
        
        // Setup genres
        self.itemInfo[self.headers[genresHeader]] = self.mediaItem!.genres
        
        // Setup More
        self.itemInfo[self.headers[moreHeader]] = self.mediaItem!.childItems
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.headers.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let header = self.headers[section]
        let rows = self.itemInfo[header]
        return rows!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }
    
        let header = self.headers[indexPath.section]
        if let sectionInfo = self.itemInfo[header] {
            let rowInfo = sectionInfo[indexPath.row]
            if let info = rowInfo as? String {
                cell!.textLabel!.text = info
            } else if let item = rowInfo as? MediaItem {
                cell!.textLabel!.text = item.title
            }
        }
        
        cell!.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell!.textLabel!.numberOfLines = 0
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headers[section]
    }
}
