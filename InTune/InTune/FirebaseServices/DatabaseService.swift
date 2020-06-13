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
    //rename to users
    static let artistPosts = "artistPost"
    static let favCollection = "favoriteArtists"
    static let gigPosts = "gigPosts"
    
    private let db = Firestore.firestore()
  static let shared = DatabaseService()
    
    //rename this to users
  public func createArtist(authDataResult: AuthDataResult, completion: @escaping (Result<Bool,Error>) -> ()){
    guard let email = authDataResult.user.email else {return}
    db.collection(DatabaseService.artistsCollection).document(authDataResult.user.uid).setData(["email": email, "artistId": authDataResult.user.uid, "createdDate": Timestamp()]){ (error) in
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
    public func fetchArtist(userID:String, completion: @escaping (Result<[Artist], Error>) -> ()) {
        guard let user = Auth.auth().currentUser,
            user.uid == userID
            else {return}
        
        
        db.collection(DatabaseService.artistsCollection).whereField("artistId", isEqualTo: userID).getDocuments { (snapshot, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let snapshot = snapshot {
                        let artist = snapshot.documents.map {Artist($0.data())}
                        completion(.success(artist))
                    }
                }
        
            }
        
    
    
//update fucntion for tags. will create a helper function that saves the "tags" to an array then we will update the database with the array.
    
    public func updateUserTags(instruments:[String], genres:[String], completion: @escaping (Result<Bool,Error>) -> () ){
        guard let user = Auth.auth().currentUser else {return}
        
        db.collection(DatabaseService.artistsCollection).document(user.uid).updateData(["instruments":instruments,"tags":genres]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                
                
                completion(.success(true))
            }
        }
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
    
    //should rename to user
    public func createGigPost(for user: Artist, gigPost: GigsPost, completion: @escaping (Result<Bool, Error>) ->()) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        db.collection(DatabaseService.artistsCollection).document(currentUser.uid).collection(DatabaseService.gigPosts).addDocument(data:
            ["user": user,
             "gigId": UUID().uuidString,
             "title": gigPost.title,
             "descript": gigPost.descript,
             "photoURL": gigPost.photoURL,
             "price": gigPost.price,
             "eventDate": gigPost.eventDate,
             "createdDate": Timestamp()
        ]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }

}

