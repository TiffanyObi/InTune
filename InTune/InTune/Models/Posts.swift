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
//    let imageURL: String?
    let price: Int
    let eventDate: String
    let createdDate: Timestamp?
    let location: String
}

extension GigsPost {
    init(_ dictionary: [String: Any]) {
        self.artistName = dictionary["artistName"] as? String ?? "no item name"
        self.artistId = dictionary["artistId"] as? String ?? "no artistId"
        self.gigId = dictionary["gigId"] as? String ?? "no gigID"
        self.title = dictionary["title"] as? String ?? "no title"
        self.descript = dictionary["descript"] as? String ?? "no description"
//        self.imageURL = dictionary["imageURL"] as? String ?? "no imageURL"
        self.price = dictionary["price"] as? Int ?? 0
        self.eventDate = dictionary["eventDate"] as? String ?? "no event date"
        self.createdDate = dictionary["createdDate"] as? Timestamp ?? Timestamp()
        self.location = dictionary["location"] as? String ?? "no location"
    }
}

struct FavGig {
    let gigId: String
    let title: String
    let artistName: String
    let artistId: String
    let description: String
    let price: Int
    let eventDate: String
    let location: String
    let favDate: Timestamp
}

extension FavGig {
    init(_ dictionary: [String: Any]) {
        self.gigId = dictionary["gigId"] as? String ?? "no gig id"
        self.title = dictionary["title"] as? String  ?? "no title"
        self.artistName = dictionary["artistName"] as? String ?? "no name"
        self.artistId = dictionary["artistId"] as? String ?? "no artistId"
        self.description = dictionary["description"] as? String ?? "no descript"
        self.price = dictionary["price"] as? Int ?? 0
        self.eventDate = dictionary["eventDate"] as? String ?? "no event date"
        self.location = dictionary["location"] as? String ?? "no location"
        self.favDate = dictionary["favDate"] as? Timestamp ?? Timestamp()
    }
}
