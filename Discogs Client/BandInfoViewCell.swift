//
//  BandInfoViewCell.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 21/09/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit
import FSPagerView
import AlamofireImage
import Alamofire

class BandInfoViewCell: UITableViewCell {

    var navController: UINavigationController? = nil
    
    @IBOutlet weak var bandName: UILabel!
    @IBOutlet weak var relatedBandsCpllectionView: UICollectionView!

    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    var imageUrls = [String]() {
        didSet {
            self.pagerView.reloadData()
        }
    }
    
    var relatedBands: [NewArtist]? {
        didSet {
            self.relatedBandsCpllectionView.reloadData()
        }
    }
    
    func configureCell (artist: NewArtist, navigationController: UINavigationController) {
        self.imageUrls = artist.images ?? [String]()
        self.bandName.text = artist.name
        self.bioTextView.text = artist.bio
        self.relatedBands = artist.relatedBands
        self.pagerView.transformer = FSPagerViewTransformer(type: .depth)
        self.navController = navigationController
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }


}

extension BandInfoViewCell: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imageUrls.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        guard let url = URL(string: imageUrls[index]) else { return cell }
        cell.imageView?.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "product--preview"))
        cell.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        cell.imageView?.layer.masksToBounds = true
        return cell
    }
}

extension BandInfoViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedBands?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "relatedBands", for: indexPath) as! BandInfoCollectionViewCell
        cell.relatedBandsLabel.text = relatedBands?[indexPath.row].name
        
        cell.sizeToFit()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BandInfo") as! BandInfoTableViewController
              
        let artistId = relatedBands?[indexPath.row].id
        vc.artistId = artistId

        navController?.show(vc, sender: self)
    }
    
}
