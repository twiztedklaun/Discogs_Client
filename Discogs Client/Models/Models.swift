//
//  Models.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 21/09/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit

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
    
    init(image: String, title: String, id: Int, year: Int) {
        self.image = image
        self.title = title
        self.id = id
        self.year = year
    }
    
    func getDetails() {
        NewSearchService.getAlbumDetails(id: self.id ?? 0, completion: { qualityImage, tracklist in
            self.qualityImage = qualityImage
            self.tracklist = tracklist
        })
    }
    
}
