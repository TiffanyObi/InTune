//
//  DatabaseService.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
class DatabaseService {
  static let artistsCollection = "artists"
  static let usersCollection = "users"
    private let db = Firestore.firestore()
  static let shared = DatabaseService()
    
  public func createArtist(artist: Artist, authDataResult: AuthDataResult, completion: @escaping (Result<Bool,Error>) -> ()){
    guard let email = authDataResult.user.email else {return}
    db.collection(DatabaseService.artistsCollection).document(authDataResult.user.uid).setData(["name": artist.name, "email": email, "tags": artist.tags, "instruments": artist.instruments, "city": artist.city]){ (error) in
      if let error = error {
        completion(.failure(error))
      } else {
        completion(.success(true))
      }
    }
  }
//  public func createMedia(imediaName: String, displayName: String, completion: @escaping (Result<String,Error>) ->()) {
//    guard let user = Auth.auth().currentUser else { return }
//    let documentRef = db.collection(DatabaseService.itemsCollection).document()
//    db.collection(DatabaseService.itemsCollection).document(documentRef.documentID).setData(["itemName" :itemName,
//                                                 "details":details,
//                                                 "id":documentRef.documentID,
//                                                 "listedDate":Timestamp(date: Date()),
//                                                 "postedBy":displayName,
//                                                 "postedById":user.uid]) { (error) in
//                                                  if let error = error {
//                                                    completion(.failure(error ))
//                                                  } else {
//                                                    completion(.success(documentRef.documentID))
//                                                  }
//    }
//  }
}