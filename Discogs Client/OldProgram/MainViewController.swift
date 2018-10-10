//
//  MainViewController.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 21/01/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit
import AlamofireImage
import Spring

class MainViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var discogsLogo: UIImageView!
    
    var artistList = [Artist]()
    let indexPathForRow = IndexPath(row: 0, section: 0)
    let userDefaultsSettings = UserDefaults.standard
    var selectedArtistId = 0
    var selectedArtistName = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlbums"{
            let vc = segue.destination as! BandViewController
            vc.artistId = selectedArtistId
            vc.artistName = selectedArtistName
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = userDefaultsSettings.data(forKey: "artistList") {
            artistList = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Artist]
            userDefaultsSettings.synchronize()
            searchTableView.backgroundView = UIImageView(image: UIImage(named: "sun-pattern"))
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        SearchService.getArtist(name: searchBar.text!, completion: { [weak self] artist in
            self?.artistList.insert(artist, at: 0)
            print(self?.artistList)
            if self!.artistList.count > 4 {
                self?.artistList.removeLast()
            }
           
            self?.searchTableView.reloadData()
            let artistData = NSKeyedArchiver.archivedData(withRootObject: self?.artistList)
            self?.userDefaultsSettings.set(artistData, forKey: "artistList")
            self?.userDefaultsSettings.synchronize()
            self?.searchTableView.reloadRows(at: [(self?.indexPathForRow)!], with: .automatic)
        })
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchId") as! MainViewControllerCell
        let currentArtist = artistList[indexPath.row]
        cell.artistSearchName.text = currentArtist.name
        
        cell.artistSearchImage.layer.shadowColor = UIColor.black.cgColor
        cell.artistSearchImage.layer.shadowOpacity = 0.5
        cell.artistSearchImage.layer.shadowOffset = CGSize.zero
        cell.artistSearchImage.layer.shadowRadius = 10
        cell.artistSearchImage.layer.shouldRasterize = true
        
        guard let url = currentArtist.image else { return cell }
        guard let tempUrl = URL(string: url) else { return cell }
        let data = try? Data(contentsOf: tempUrl)
        let image: UIImage = UIImage(data: data!)!
        cell.artistSearchImage.image = image.af_imageRoundedIntoCircle()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArtistId = artistList[indexPath.row].id ?? 0
        selectedArtistName = artistList[indexPath.row].name ?? ""
        self.performSegue(withIdentifier: "toAlbums", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}
