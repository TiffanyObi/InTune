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
    static let favGigPosts = "favGigPosts"
    static let threadCollection = "thread"
    static let artVideos = "videos"
    static let reportCollection = "reported"
    
    private let db = Firestore.firestore()
  static let shared = DatabaseService()
    
    //rename this to users
  public func createArtist(authDataResult: AuthDataResult, completion: @escaping (Result<Bool,Error>) -> ()){
    guard let email = authDataResult.user.email else {return}
    db.collection(DatabaseService.artistsCollection).document(authDataResult.user.uid).setData(["email": email, "artistId": authDataResult.user.uid, "createdDate": Timestamp(),"isReported":false]){ (error) in
      if let error = error {
        completion(.failure(error))
      } else {
        completion(.success(true))
      }
    }
  }
    
    public func createThread(artist: Artist, completion: @escaping (Result<Bool, Error>)->()) {
        guard let artistId = Auth.auth().currentUser?.uid else {return}
        db.collection(DatabaseService.artistsCollection).document(artistId).collection(DatabaseService.threadCollection).document(artist.artistId).setData(["name" : artist.name, "artistId": artist.artistId, "photoURL": artist.photoURL ?? "no photo url", "city": artist.city]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func createThread2(sender: Artist, artist: Artist, completion: @escaping (Result<Bool, Error>)->()) {
         let artistId = sender.artistId
        db.collection(DatabaseService.artistsCollection).document(artistId).collection(DatabaseService.threadCollection).document(Auth.auth().currentUser!.uid).setData(["name" : artist.name, "artistId": artist.artistId, "photoURL": artist.photoURL ?? "no photo url", "city": artist.city]) { (error) in
               if let error = error {
                   completion(.failure(error))
               } else {
                   completion(.success(true))
               }
           }
       }
    
    public func fetchThread(sender: Artist, artist: Artist, completion: @escaping (Result<[Message?], Error>)->()) {
        let artistId = sender.artistId
        
        db.collection(DatabaseService.artistsCollection).document(artistId).collection(DatabaseService.threadCollection).getDocuments { (snapshot, error) in
            
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let messages = snapshot.documents.map { Message(dictionary: $0.data()) }
                completion(.success(messages))
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
        user.createProfileChangeRequest().displayName = userName
        
        db.collection(DatabaseService.artistsCollection).document(user.uid).updateData(["name": userName, "city":location]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
        
    }
    
    //fetch artist
    public func fetchArtist(userID:String ,completion: @escaping (Result<Artist, Error>) -> ()) {
       
        db.collection(DatabaseService.artistsCollection).document(userID).getDocument { (snapshot, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let snapshot = snapshot {
                        guard let data = snapshot.data() else {return}
                        let artist = Artist(data)
                        completion(.success(artist))
                    }
                }
        
            }
    
    public func getArtists(completion:@escaping (Result<[Artist], Error>) -> ()) {
        db.collection(DatabaseService.artistsCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let artists = snapshot.documents.compactMap { Artist($0.data())}
                completion(.success(artists))
            }
            
        }
    }
        
    
    
//update fucntion for tags. will create a helper function that saves the "tags" to an array then we will update the database with the array.
    
    public func updateUserTags(instruments:[String], genres:[String], completion: @escaping (Result<Bool,Error>) -> () ){
        guard let user = Auth.auth().currentUser else {return}
        
        var tags = [String]()
        tags.append(contentsOf: instruments)
        tags.append(contentsOf: genres)
        
        db.collection(DatabaseService.artistsCollection).document(user.uid).updateData(["tags":tags,"preferences":tags]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                
                
                completion(.success(true))
            }
        }
    }
    
    public func updateDisplayName(name: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.artistsCollection).document(user.uid).updateData(["name": name]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func updateUserPhoto(_ user: User, photoURL:String, completion:@escaping (Result<Bool,Error>) -> ()){
        db.collection(DatabaseService.artistsCollection).document(user.uid).updateData(["photoURL":photoURL]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func createVideoPosts(post: Video, completion: @escaping (Result<Bool, Error>) -> ()) {
      guard let user = Auth.auth().currentUser else {return}
      db.collection(DatabaseService.artistsCollection).document(user.uid).collection(DatabaseService.artVideos).document().setData(["videos": post.urlString ?? "no string"]) { (error) in
        if let error = error {
          completion(.failure(error))
        } else {
          completion(.success(true))
        }
      }
    }
    
    public func getVideo(artist:Artist,completion: @escaping (Result<[Video], Error>) -> ()){
        db.collection(DatabaseService.artistsCollection).document(artist.artistId).collection(DatabaseService.artVideos).getDocuments { (snapshot, error) in
        if let error = error{
          completion(.failure(error))
        } else if let snapshot = snapshot{
          let videoDocuments = snapshot.documents.map{$0.data()}
          var videos = [Video]()
          videos = videoDocuments.compactMap {Video($0)}
          completion(.success(videos))
        }
      }
    }
    
   
    public func createFavArtist(artist:Artist, completion: @escaping (Result <Bool,Error>) -> ()){
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection(DatabaseService.artistsCollection).document(user.uid).collection(DatabaseService.favCollection).document(artist.artistId).setData(["favArtistName":artist.name,"favArtistID":artist.artistId, "favArtistLocation":artist.city,"favArtistTag":artist.tags, "favoritedDate":Timestamp(date: Date()), "favPhotoURL": artist.photoURL ?? "no url"]){ (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func isArtistInFav(for artist: Artist, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection(DatabaseService.artistsCollection).document(user.uid).collection(DatabaseService.favCollection).whereField("favArtistID", isEqualTo: artist.artistId).getDocuments { (snapshot, error) in
            
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let count = snapshot.documents.count
                if count > 0 {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }
        }
    }
    
    public func fetchFavArtists(artist: Artist, completion: @escaping (Result<[FavoritedArtist], Error>) -> ()) {
        
        db.collection(DatabaseService.artistsCollection).document(artist.artistId).collection(DatabaseService.favCollection).getDocuments { (snapshot, error) in
            
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let favArtists = snapshot.documents.compactMap { FavoritedArtist($0.data())}
                completion(.success(favArtists))
            }
        }
        
    }
    
    public func deleteFavArtist(for artist: Artist, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection(DatabaseService.artistsCollection).document(user.uid).collection(DatabaseService.favCollection).document(artist.artistId).delete { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
        
    }
    
    
    public func updateUserPreferences(_ preferences:[String], completion:
        @escaping (Result<Bool,Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection(DatabaseService.artistsCollection).document(user.uid).updateData(["preferences": preferences]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func createGig(artist: Artist, title: String, description: String, price: Int, eventDate: String, createdDate: Timestamp, location: String, completion: @escaping (Result<String, Error>)-> ()) {
        
        let documentRef = db.collection(DatabaseService.gigPosts).document()
        
        db.collection(DatabaseService.gigPosts).document(documentRef.documentID).setData(["title" : title, "artistName": artist.name, "artistId": artist.artistId, "descript": description, "price": price, "eventDate": eventDate, "createdDate": Timestamp(), "location": location]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(documentRef.documentID))
            }
        }
        
    }
    
    public func createGigPost(artist: Artist, title: String, description: String, price: Int, eventDate: String, createdDate: Timestamp, location: String, completion: @escaping (Result<Bool, Error>)-> ()) {
        
        let documentRef = db.collection(DatabaseService.gigPosts).document()
        
        db.collection(DatabaseService.artistsCollection).document(artist.artistId).collection(DatabaseService.gigPosts).document(documentRef.documentID).setData(["title" : title, "artistName": artist.name, "artistId": artist.artistId, "descript": description, "price": price, "eventDate": eventDate, "createdDate": Timestamp(), "location": artist.city]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        
        }
    }
    
    public func fetchGigs(completion: @escaping (Result<[GigsPost], Error>) -> ()) {
        
        db.collection(DatabaseService.gigPosts).getDocuments { (snapshot, error) in
            
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let gigs = snapshot.documents.compactMap { GigsPost($0.data())}
                completion(.success(gigs))
            }
        }
    }
    
    public func favoriteGig(artist: Artist, gigPost: GigsPost, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        let documentRef = db.collection(DatabaseService.favGigPosts).document()
        
        db.collection(DatabaseService.artistsCollection).document(artist.artistId).collection(DatabaseService.favGigPosts).document(documentRef.documentID).setData(["title": gigPost.title, "artistName": gigPost.artistName, "artistId": gigPost.artistId, "description": gigPost.descript, "price": gigPost.price, "eventDate": gigPost.eventDate, "location": gigPost.location, "favDate": Timestamp()]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
        
    }
    
    public func getLikedArtistGigPosts(likedArtist:FavoritedArtist, completion:@escaping (Result<[GigsPost],Error>) -> ()){
        db.collection(DatabaseService.artistsCollection).document(likedArtist.favArtistID).collection(DatabaseService.gigPosts).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let gigPosts = snapshot.documents.map { GigsPost($0.data())
                }
                completion(.success(gigPosts))
            }
        }
    }
    

    public func reportArtist(for artist: Artist, completion: @escaping (Result<Bool, Error>) -> ()) {
        db.collection(DatabaseService.artistsCollection).document(artist.artistId).updateData(["isReported":true]){ (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
            }
        }
    
    public func deleteArtist(for artist: Artist, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.artistsCollection).document(user.uid).delete { (error) in
            if let error = error {
                completion(.failure(error))
                } else {
                completion(.success(true))
            }
        }
    }
    
}

