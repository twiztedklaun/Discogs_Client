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
    
//    var albumList = [NewAlbum]()
    
    var mainAlbumList = [NewAlbum]()
    var appearanceAlbumList = [NewAlbum]()
    var trackAppearanceAlbumList = [NewAlbum]()
    var unofficialReleasesAlbumList = [NewAlbum]()
    
    let sectionTitles = ["","Main Releases", "Artist Appeared on Release", "Track Appearance", "Unofficial Releases"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.largeTitleDisplayMode = .never
        
        NewSearchService.getArtist(id: artistId!, completion: { newArtist in
            self.artist = newArtist
            self.tableView.reloadData()
        })
        NewSearchService.getAlbums(artistId: artistId!, completion: { albumList in
            
            for album in albumList {
                switch album.role {
                    case "Main":
                        self.mainAlbumList.append(album)
                    case "Appearance":
                        self.appearanceAlbumList.append(album)
                    case "TrackAppearance":
                        self.trackAppearanceAlbumList.append(album)
                    case "UnofficialRelease":
                        self.unofficialReleasesAlbumList.append(album)
                    default:
                        self.mainAlbumList.append(album)
                }
            }
            
            self.tableView.reloadData()
        })
    }

   

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return mainAlbumList.count
        case 2:
            return appearanceAlbumList.count
        case 3:
            return trackAppearanceAlbumList.count
        case 4:
            return unofficialReleasesAlbumList.count
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
                guard let id = mainAlbumList[indexPath.row].id else { return }
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
            cell.pagerView.transformer = FSPagerViewTransformer(type: .depth)
            cell.navController = self.navigationController
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bandAlbumCell", for: indexPath) as! BandAlbumsCell
            if let imageURL = mainAlbumList[indexPath.row].image {
                if let url = URL(string: imageURL) {
                    cell.albumImage?.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "product--preview"))
                }
            }
            cell.albumYear.text = String(describing: mainAlbumList[indexPath.row].year!)
            cell.albumTitle.text = mainAlbumList[indexPath.row].title
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bandAlbumCell", for: indexPath) as! BandAlbumsCell
            if let imageURL = appearanceAlbumList[indexPath.row].image {
                if let url = URL(string: imageURL) {
                    cell.albumImage?.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "product--preview"))
                }
            }
            cell.albumYear.text = String(describing: appearanceAlbumList[indexPath.row].year!)
            cell.albumTitle.text = appearanceAlbumList[indexPath.row].title
            
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bandAlbumCell", for: indexPath) as! BandAlbumsCell
            if let imageURL = trackAppearanceAlbumList[indexPath.row].image {
                if let url = URL(string: imageURL) {
                    cell.albumImage?.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "product--preview"))
                }
            }
            cell.albumYear.text = String(describing: trackAppearanceAlbumList[indexPath.row].year!)
            cell.albumTitle.text = trackAppearanceAlbumList[indexPath.row].title
            
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bandAlbumCell", for: indexPath) as! BandAlbumsCell
            if let imageURL = unofficialReleasesAlbumList[indexPath.row].image {
                if let url = URL(string: imageURL) {
                    cell.albumImage?.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "product--preview"))
                }
            }
            cell.albumYear.text = String(describing: unofficialReleasesAlbumList[indexPath.row].year!)
            cell.albumTitle.text = unofficialReleasesAlbumList[indexPath.row].title
            
            return cell
        }
        fatalError()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
}




