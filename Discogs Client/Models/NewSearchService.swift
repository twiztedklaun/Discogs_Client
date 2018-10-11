//
//  NewSearchService.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 21/09/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewSearchService {
    static let baseURL = "https://api.discogs.com/"
    
    
    static func findArtist(name: String, completion: @escaping ([Artist]) -> Void) {
        let databaseSearch = "database/search"
        let parameters: Parameters = [
            "q" : name,
            "type" : "artist",
            "key" : "GRotkKVHOslgzJkcAcdG",
            "secret" : "MfUPtAHUaIedWylwAZkhNJkYeJGswXCh"
        ]
        
        Alamofire.request(baseURL+databaseSearch, parameters: parameters).responseJSON(completionHandler: { response in
            if let result = response.result.value {
                let responseJson = JSON(result)
                var artistList = [Artist]()
                
                for jsonArtist in responseJson["results"].arrayValue {
                    artistList.append(Artist(name: jsonArtist["title"].stringValue,
                                             id: jsonArtist["id"].intValue,
                                             image: jsonArtist["thumb"].stringValue))
                }
                completion(artistList)
            }
        })
    }
    
    static func getArtist(id: Int, completion: @escaping (NewArtist) -> Void) {
        let databaseSearch = "artists/\(id)"
        let parameters: Parameters = [
            "key" : "GRotkKVHOslgzJkcAcdG",
            "secret" : "MfUPtAHUaIedWylwAZkhNJkYeJGswXCh"
        ]
        
        Alamofire.request(baseURL+databaseSearch, parameters: parameters).responseJSON(completionHandler: { response in
            if let result = response.result.value {
                let responseJson = JSON(result)
                guard let artist = NewArtist(json: responseJson) else { fatalError() }
                completion(artist)
            }
        })
    }
    
    static func getAlbumDetails(id: Int, completion: @escaping(_ qualityImage: String, _ tracklist: [String]) -> ()) {
        let albumUrl = "masters/\(id)"
        let parameters: Parameters = [
            "key" : "GRotkKVHOslgzJkcAcdG",
            "secret" : "MfUPtAHUaIedWylwAZkhNJkYeJGswXCh"
        ]
        
        Alamofire.request(Album.baseURL+albumUrl, method: .get, parameters: parameters).responseJSON(completionHandler: { response in
            if let result = response.result.value {
                let responseJson = JSON(result)
                let qualityImage = responseJson["images"][0]["uri"].stringValue
                var tracklist = [String]()
                for (_, track) in responseJson["tracklist"] {
                    tracklist.append(track["title"].stringValue)
                }
                completion(qualityImage, tracklist)
            }
        })
    }
    
    
    
    static func getArtistImages(artistId: Int, completion: @escaping ([String]) -> Void) {
        let artistUrl = "artists/\(artistId)"
        let parameters: Parameters = [
            "key" : "GRotkKVHOslgzJkcAcdG",
            "secret" : "MfUPtAHUaIedWylwAZkhNJkYeJGswXCh"
        ]
        
        Alamofire.request(baseURL+artistUrl, parameters: parameters).responseJSON(completionHandler: { response in
            if let result = response.result.value {
                let responseJson = JSON(result)
                print(responseJson)
                var artistImageList = [String]()
                
                for (_, image) in responseJson["images"] {
                    let artistImage = image["resource_url"].stringValue
                    artistImageList.append(artistImage)
                }
                completion(artistImageList)
            }
        })
    }
    
    static func getAlbums(artistId: Int, completion: @escaping ([NewAlbum]) -> Void) {
        let artistReleaseUrl = "artists/\(artistId)/releases"
        let parameters: Parameters = [
            "sort" : "year",
            "per_page" : "400",
            "key" : "GRotkKVHOslgzJkcAcdG",
            "secret" : "MfUPtAHUaIedWylwAZkhNJkYeJGswXCh"
        ]
        
        Alamofire.request(baseURL+artistReleaseUrl, parameters: parameters).responseJSON(completionHandler: { response in
            if let result = response.result.value {
                let responseJson = JSON(result)
                //                print(responseJson)
                var albumsList = [NewAlbum]()
                for (_, release) in responseJson["releases"] {
                    let album = NewAlbum(image: release["thumb"].stringValue, title: release["title"].stringValue, id: release["id"].intValue, year: release["year"].intValue)
                    albumsList.append(album)
                }
                completion(albumsList)
            }
        })
    }
}
    



