//
//  LyricsViewController.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 12/05/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit
import Alamofire

class LyricsViewController: UIViewController {

    @IBOutlet weak var lyricsView: UITextView!
    var lyrics = Lyrics(trackId: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        getLyricsId(trackName: lyrics.trackName!, completion: { trackId in
            getLyrics(trackId: trackId, completion: { (lyrics) in
                self.lyrics.lyricsBody = lyrics
                if self.lyrics.lyricsBody != nil {
                    DispatchQueue.main.async {
                        self.lyricsView.text = lyrics
                    }
                }
            })
        })
    }

}
