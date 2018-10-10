//
//  SearchTableViewController.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 16/09/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit
import AlamofireImage

class SearchTableViewController: UITableViewController {
    
    @IBOutlet weak var navItemFromStoryboard: UINavigationItem!
    
    
    let search = UISearchController(searchResultsController: nil)
    var artistArray = [Artist]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navItemFromStoryboard.searchController = search
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.tintColor = Colors.veryLight
        search.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //        search.searchResultsUpdater = self
        
        search.isActive = false
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Type something here to search", attributes: [NSAttributedStringKey.foregroundColor: Colors.slightlyLighter])
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: Colors.veryLight]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navItemFromStoryboard.title = "Search"
        
        tableView.backgroundColor = Colors.slightlyLighter
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBandVC" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    guard let newVC = segue.destination as? BandInfoTableViewController else { return }
                    guard let id = artistArray[indexPath.row].id else { return }
                    newVC.artistId = id
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as! SearchTableViewCell
        cell.artistLabel.text = artistArray[indexPath.row].name
        
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.23
        cell.layer.shadowRadius = 4
        
        guard let url = artistArray[indexPath.row].image else { return cell }
        guard let tempUrl = URL(string: url) else { return cell }
        let data = try? Data(contentsOf: tempUrl)
        let image: UIImage = UIImage(data: data!)!
        cell.artistImage.image = image.af_imageRoundedIntoCircle()
        cell.backgroundColor = UIColor.lightText

        return cell
    }

}

//extension SearchTableViewController: UISearchResultsUpdating {
//
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text else { return }
//
//        }
//    }


extension SearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
            NewSearchService.findArtist(name: text, completion: { [weak self] artists in
                if artists.count > 0 {
                    self?.artistArray.append(artists[0])
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            })
        }
    }

