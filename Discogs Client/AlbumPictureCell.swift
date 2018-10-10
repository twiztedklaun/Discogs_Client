//
//  AlbumPictureCell.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 10/10/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class AlbumPictureCell: UITableViewCell {

    
    @IBOutlet weak var albumImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

