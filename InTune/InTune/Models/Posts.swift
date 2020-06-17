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
    let imageURL: String
    let price: Int
    let eventDate: String
    let createdDate: Timestamp?
}

extension GigsPost {
    init(_ dictionary: [String: Any]) {
        self.artistName = dictionary["artistName"] as? String ?? "no item name"
        self.artistId = dictionary["artistId"] as? String ?? "no artistId"
        self.gigId = dictionary["gigId"] as? String ?? "no gigID"
        self.title = dictionary["title"] as? String ?? "no title"
        self.descript = dictionary["descript"] as? String ?? "no description"
        self.imageURL = dictionary["imageURL"] as? String ?? "no imageURL"
        self.price = dictionary["price"] as? Int ?? 0
        self.eventDate = dictionary["eventDate"] as? String ?? "no event date"
        self.createdDate = dictionary["createdDate"] as? Timestamp ?? Timestamp()
    }
}

//extension Item {
//    init(_ dictionary: [String:Any]) {
//        self.itemName = dictionary["itemName"] as? String ?? "no item name"
//        self.price = dictionary["price"] as? Double ?? 0.0
//        self.itemId = dictionary["itemId"] as? String ?? "No item id"
//        self.listedData = dictionary["listedData"] as? Timestamp ?? Timestamp()
//        self.sellerName = dictionary["sellerName"] as? String ?? "No seller name"
//        self.sellerId = dictionary["sellerId"] as? String ?? "No seller id"
//        self.categoryName = dictionary["categoryName"] as? String ?? "no category name"
//        self.imageURL = dictionary["imageURL"] as? String ?? "no image urk"
//    }
//}

//extension GigsPost {
//    init?(_ dictionary: [String: Any]) {
//        guard let gigId = dictionary["gigId"] as? String,
//        let artistName = dictionary["artistName"] as? String,
//        let artistId = dictionary["artistId"] as? String,
//        let title = dictionary["title"] as? String,
//        let descript = dictionary["descript"] as? String,
//        let photoURL = dictionary["photoURL"] as? String,
//        let price = dictionary["price"] as? Int,
//        let eventDate = dictionary["eventDate"] as? String,
//            let createDate = dictionary["createdDate"] as? Timestamp else {
//                return nil
//        }
//
//        self.gigId = gigId
//        self.artistName = artistName
//        self.artistId = artistId
//        self.title = title
//        self.descript = descript
//        self.photoURL = photoURL
//        self.price = price
//        self.eventDate = eventDate
//        self.createdDate = createDate
//    }
//}
