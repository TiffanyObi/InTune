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
    let favoritedArtist: Artist
    let favoritedDate: Timestamp
    let note: String? // if users want to favorite an Artist with a specific reason why they are liking it (i.e to book for an event or contacts at a later date etc) but we dont have to keep this.
    
    
}

extension FavoritedArtist{
    
    init(_ dictionary:[String:Any]){
        self.favoritedArtist = dictionary["favoritedArtist"] as? Artist ?? Artist(name: "no name", artistId: "no id", instruments: [""], tags: [""], city: "", isAnArtist: Bool(), createdDate: Timestamp(date:Date()))
        
        self.favoritedDate = dictionary["favoritedDate"] as? Timestamp ?? Timestamp(date: Date())
        self.note = dictionary["note"] as? String ?? "no note"
    }
    
}
