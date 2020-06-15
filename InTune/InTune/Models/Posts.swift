//
//  Post.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation
import Firebase

struct ArtistPost {
    let artistName: String
    let artistId: String
    let postId: String
    let postedDate: Timestamp
    let postURL: String
}

extension ArtistPost {
    init?(_ dictionary: [String: Any]) {
        guard let artistName = dictionary["artistName"] as? String,
        let artistId = dictionary["artistId"] as? String,
        let postId = dictionary["postId"] as? String,
        let postedDate = dictionary["postedDate"] as? Timestamp,
            let postURL = dictionary["postURL"] as? String else {
                return nil
        }
        self.artistName = artistName
        self.artistId = artistId
        self.postId = postId
        self.postedDate = postedDate
        self.postURL = postURL
    }
}


//for gigs
struct GigsPost {
//    let user: Artist  This might/does not work since we tried it in favorites model
    //based on bool
    let artistName: String
    let artistId: String
    let gigId: String
    let title: String
    let descript: String
    let photoURL: String
    let price: Int
    let eventDate: String
    let createdDate: Timestamp?
}

extension GigsPost {
    init?(_ dictionary: [String: Any]) {
        guard let gigId = dictionary["gigId"] as? String,
        let artistName = dictionary["artistName"] as? String,
        let artistId = dictionary["artistId"] as? String,
        let title = dictionary["title"] as? String,
        let descript = dictionary["descript"] as? String,
        let photoURL = dictionary["photoURL"] as? String,
        let price = dictionary["price"] as? Int,
        let eventDate = dictionary["eventDate"] as? String,
            let createDate = dictionary["createdDate"] as? Timestamp else {
                return nil
        }
    
        self.gigId = gigId
        self.artistName = artistName
        self.artistId = artistId
        self.title = title
        self.descript = descript
        self.photoURL = photoURL
        self.price = price
        self.eventDate = eventDate
        self.createdDate = createDate
    }
}
