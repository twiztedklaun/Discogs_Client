//
//  BandAlbumsCell.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 21/09/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit

class BandAlbumsCell: UITableViewCell {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumYear: UILabel!
    
    func configureCell (album: NewAlbum) {
        if let imageURL = album.image {
            if let url = URL(string: imageURL) {
                self.albumImage?.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "product--preview"))
            }
        }
        self.albumYear.text = String(describing: album.year!)
        self.albumTitle.text = album.title
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
