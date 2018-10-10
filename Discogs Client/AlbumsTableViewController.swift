//
//  AlbumsTableViewController.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 10/10/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit
import AlamofireImage

class AlbumsTableViewController: UITableViewController {
    
    var albumId: Int?
    var image: String?
    var songList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NewSearchService.getAlbumDetails(id: albumId!, completion: { albumImage, trackList in
            self.image = albumImage
            self.songList = trackList
            self.tableView.reloadData()
        })
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return songList.count
        default:
            fatalError()
            }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 500
        } else {
            return 45
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "albumPicture") as! AlbumPictureCell
            if let albumImage = image {
                cell.albumImage.af_setImage(withURL: URL(string: albumImage)!)
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lyricsList") as! TracklistCell
            cell.trackList = songList
            cell.lyricsLabel.text = "\(indexPath.row + 1). " + songList[indexPath.row]
            return cell
        }
        fatalError()
    }
    
}

    


