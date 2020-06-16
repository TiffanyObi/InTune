//
//  Artist.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation
import Firebase

//renamed to user
struct Artist {
  let name: String
  let email:String
  let artistId: String
  let tags: [String]
  let city: String
  let isAnArtist:Bool
  let createdDate: Timestamp
  let photoURL:String?
  let preferences:[String]?
//  let isFavorite: Bool?

}
extension Artist {
  init(_ dictionary: [String: Any]) {
    self.name = dictionary["name"] as? String ?? "No Artist"
    self.artistId = dictionary["artistId"] as? String ?? "UUID().uuidString"
//    self.instruments = dictionary["instruments"] as? [String] ?? ["no instrument"]
    self.tags = dictionary["tags"] as? [String] ?? ["no tags"]
    self.city = dictionary["city"] as? String ?? "No City selected"
    self.isAnArtist = dictionary["isAnArtist"] as? Bool ?? false
    self.createdDate = dictionary["createdDate"] as? Timestamp ?? Timestamp(date: Date())
    self.email = dictionary["email"] as? String ?? "no email"
    self.photoURL = dictionary["photoURL"] as? String ?? "no URL"
    self.preferences = dictionary["preferences"] as? [String] ?? [""]
//    self.isFavorite = dictionary["isFavorite"] as? Bool ?? false
  }
}




