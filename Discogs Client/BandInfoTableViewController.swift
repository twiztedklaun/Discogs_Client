//
//  BandInfoTableViewController.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 21/09/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit
import FSPagerView
import AlamofireImage
import Alamofire

class BandInfoTableViewController: UITableViewController {
    
    var artistId: Int?
    var artist: NewArtist?
    var albumList = [NewAlbum]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.largeTitleDisplayMode = .never
        
        
        NewSearchService.getArtist(id: artistId!, completion: { newArtist in
            self.artist = newArtist
            self.tableView.reloadData()
        })
        NewSearchService.getAlbums(artistId: artistId!, completion: { albumList in
            self.albumList = albumList
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
            return albumList.count
        default:
            fatalError()
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
           return 500
        } else {
            return 120
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlbums" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let newVC = segue.destination as? AlbumsTableViewController else { return }
                guard let id = albumList[indexPath.row].id else { return }
                newVC.albumId = id
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bandInfoCell", for: indexPath) as! BandInfoViewCell
            cell.imageUrls = artist?.images ?? [String]()
            cell.bandName.text = artist?.name
            cell.bioTextView.text = artist?.bio
            cell.relatedBands = artist?.relatedBands
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bandAlbumCell", for: indexPath) as! BandAlbumsCell
            if let imageURL = albumList[indexPath.row].image {
                if let url = URL(string: imageURL) {
                    cell.albumImage?.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "product--preview"))
                }
            }
            cell.albumYear.text = String(describing: albumList[indexPath.row].year!)
            cell.albumTitle.text = albumList[indexPath.row].title
            return cell
        }
        fatalError()
    }
}




