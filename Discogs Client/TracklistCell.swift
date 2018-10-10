//
//  TracklistCell.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 10/10/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit

class TracklistCell: UITableViewCell {

    @IBOutlet weak var lyricsLabel: UILabel!
    
    var trackList = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
