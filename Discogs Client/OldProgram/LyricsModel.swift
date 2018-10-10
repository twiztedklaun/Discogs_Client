//
//  LyricsModel.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 12/05/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Lyrics {
    var trackId: Int
    var trackName: String?
    var lyricsBody: String?
    static let apiKey = "ad27012eb0257e7c12fcb9a7d620d9a6"
    
    init(trackId: Int) {
        self.trackId = trackId
    }
}

func getLyricsId (trackName: String, completion: @escaping (Int) -> Void) {
    let baseUrl = "http://api.musixmatch.com/ws/1.1/track.search"
    let parameters: Parameters = [
        "q_track" : trackName,
        "apikey" : Lyrics.apiKey
    ]
    Alamofire.request(baseUrl, method: .get, parameters: parameters).responseJSON { (response) in
        guard let value = response.result.value else { return }
        let json = JSON(value)
        let trackId = json["message"]["body"]["track_list"][0]["track"]["track_id"].intValue
        completion(trackId)
    }
}

func getLyrics (trackId: Int, completion: @escaping (String) -> Void) {
    let baseUrl = "http://api.musixmatch.com/ws/1.1/track.lyrics.get"
    let parameters: Parameters = [
        "track_id" : trackId,
        "apikey" : Lyrics.apiKey
    ]
    Alamofire.request(baseUrl, method: .get, parameters: parameters).responseJSON { (response) in
        guard let value = response.result.value else { return }
        let json = JSON(value)
        let lyrics = json["message"]["body"]["lyrics"]["lyrics_body"].stringValue
        print(lyrics)
        completion(lyrics)
    }
}
