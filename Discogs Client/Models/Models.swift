//
//  Models.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 21/09/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewArtist: NSObject, NSCoding {
    
    var name: String?
    var id: Int?
    var images: [String]?
    var bio: String?
    var relatedBands: [NewArtist]?
    
    init(name: String?, id: Int?, images: [String]?, bio: String?, relatedBands: [NewArtist]?) {
        self.name = name
        self.id = id
        self.images = images
        self.bio = bio
        self.relatedBands = relatedBands
    }
    
    init? (json: JSON) {
            let name = json["name"].stringValue
            let id = json["id"].intValue
            let images = json["images"].arrayValue.map({$0["uri"].stringValue})
            let bio = json["profile"].stringValue
            let relatedBands = json["groups"].arrayValue.map({ NewArtist(name: $0["name"].stringValue, id: $0["id"].intValue, images: nil, bio: nil, relatedBands: nil) })
    
        self.name = name
        self.id = id
        self.images = images
        self.bio = bio
        self.relatedBands = relatedBands
}
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.id = decoder.decodeObject(forKey: "id") as? Int ?? 0
        self.images = decoder.decodeObject(forKey: "images") as? [String] ?? []
        self.bio = decoder.decodeObject(forKey: "bio") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(id, forKey: "id")
        coder.encode(images, forKey: "images")
        coder.encode(bio, forKey: "bio")
    }
}

class NewAlbum {
    var image: String?
    var title: String?
    var id: Int?
    var year: Int?
    var tracklist = [String]()
    var qualityImage = ""
    var role: String?
    
    init(image: String, title: String, id: Int, year: Int, role: String) {
        self.image = image
        self.title = title
        self.id = id
        self.year = year
        self.role = role
    }
    
    func getDetails() {
        NewSearchService.getAlbumDetails(id: self.id ?? 0, completion: { qualityImage, tracklist in
            self.qualityImage = qualityImage
            self.tracklist = tracklist
        })
    }
}

class UserProfile {
    var username: String?
    var profileText: String?
    var name: String?
    var avatar: String?
    var homePage: String?
    var location: String?
    var currency: String?
    var rank: Int?
    var sellerRank: Int?
    var buyerRank: Int?
    
    init(username: String, profileText: String, name: String, avatar: String, homePage: String, location: String, currency: String, rank: Int, sellerRank: Int, buyerRank: Int) {
        self.username = username
        self.profileText = profileText
        self.name = name
        self.avatar = avatar
        self.homePage = homePage
        self.location = location
        self.currency = currency
        self.rank = rank
        self.sellerRank = sellerRank
        self.buyerRank = buyerRank
    }
    
    init? (json: JSON) {
        let jsonDictionary = json.dictionary!
        self.name = jsonDictionary["username"]?.stringValue
        self.avatar = jsonDictionary["avatar_url"]?.stringValue
        self.username = jsonDictionary["username"]?.stringValue
        self.profileText = jsonDictionary["profile"]?.stringValue
        self.homePage = jsonDictionary["home_page"]?.stringValue
        self.location = jsonDictionary["location"]?.stringValue
        self.currency = jsonDictionary["curr_abbr"]?.stringValue
        self.rank = jsonDictionary["rank"]?.intValue
        self.sellerRank = jsonDictionary["seller_rating"]?.intValue
        self.buyerRank = jsonDictionary["buyer_rating"]?.intValue
    }
}
