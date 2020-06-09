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
    private let db = Firestore.firestore()
  static let shared = DatabaseService()
    
  public func createArtist(authDataResult: AuthDataResult, completion: @escaping (Result<Bool,Error>) -> ()){
    guard let email = authDataResult.user.email else {return}
    db.collection(DatabaseService.artistsCollection).document(authDataResult.user.uid).setData(["email": email, "userId": authDataResult.user.uid, "createdDate": Timestamp()]){ (error) in
      if let error = error {
        completion(.failure(error))
      } else {
        completion(.success(true))
      }
    }
  }
    
    
    
    //update function for user experience ( isAnArtist == true )
    public func updateUserExperience(isAnArtist:Bool, completion: @escaping (Result<Bool,Error>) -> ()){
        
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection(DatabaseService.artistsCollection).document(user.uid).updateData(["isAnArtist": isAnArtist]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
        
    }
    
    
    
    
    // update function for user Name
    
    
    //update fucntion for tags. will create a helper function that saves the "tags" to an array then we will update the database with the array.
    
    
    
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
