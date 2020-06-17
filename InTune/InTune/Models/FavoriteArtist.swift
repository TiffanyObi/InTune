//
//  FavoriteArtist.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation
import Firebase

struct FavoritedArtist {
    let favArtistName:String
    let favArtistLocation:String
    let favArtistID:String
    let favArtistTag:[String]
    let favoritedDate: Timestamp
//    let note: String? // if users want to favorite an Artist with a specific reason why they are liking it (i.e to book for an event or contacts at a later date etc) but we dont have to keep this.
}

extension FavoritedArtist{

    init(_ dictionary:[String:Any]){
        self.favArtistID = dictionary["favArtistID"] as? String ?? "noFavID"
        self.favArtistLocation = dictionary["favArtistLocation"] as? String ?? "no favArtistLocation"
        self.favArtistName = dictionary["favArtistName"] as? String ?? "no favArtistName"
        self.favArtistTag = dictionary["favArtistTag"] as? [String] ?? ["no favArtistTag"]
        self.favoritedDate = dictionary["favoritedDate"] as? Timestamp ?? Timestamp(date: Date())

    }

}
