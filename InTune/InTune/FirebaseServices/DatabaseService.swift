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
    static let artistPosts = "artistPost"
    static let favCollection = "favoriteArtists"
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
    
    
    
    
    // update function for user Name and location
    
    public func updateUserDisplayNameAndLocation(userName:String, location:String, completion: @escaping (Result<Bool,Error>) -> ()){
        
        guard let user = Auth.auth().currentUser else {return}
        
        db.collection(DatabaseService.artistsCollection).document(user.uid).updateData(["name": userName, "city":location]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
        
    }
    
    //fetch artist
    public func fetchArtist(completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        
//        db.collection(DatabaseService.artistsCollection).document(user.uid).get
    }
    
    public func createVideoPosts(post: ArtistPost, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser else {return}
        
        db.collection(DatabaseService.artistsCollection).document(user.uid).collection(DatabaseService.artistPosts).addDocument(data: ["videos" : post.postURL]) { (error) in
            //add all elements here later
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    public func createFavoriteArtist(artist: Artist,completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.artistsCollection).document(user.uid).collection(DatabaseService.favCollection).addDocument(data: ["favoritedArtist": artist, "favoritedDate": Timestamp()]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    public func isArtistInFav(for artist: Artist, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
    }
}
