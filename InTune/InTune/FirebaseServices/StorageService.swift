//
//  StorageService.swift
//  InTune
//
//  Created by Maitree Bain on 5/28/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class StorageService {
    private let storageRef = Storage.storage().reference()
    public func uploadPhoto(userId: String? = nil, itemId: String? = nil, image: UIImage, completion: @escaping (Result<URL, Error>) -> ()) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        var photoReference: StorageReference!
        if let userId = userId {
            photoReference = storageRef.child("UserProfilePhotos/\(userId).jpg")
        } else if let itemId = itemId {
            photoReference = storageRef.child("ItemsPhotos/\(itemId).jpg")
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        let _ = photoReference.putData(imageData, metadata: metadata) {
            (metadata, error) in
            if let error = error {
                completion(.failure(error))
            }else if let metadata = metadata {
                photoReference.downloadURL { (url, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
            }
        }
    }
func uploadVideoData(_ videoData: Data, completion: @escaping (Result<Bool, Error>) -> ()){
 guard let user = Auth.auth().currentUser else {
  return
 }
 let storageRef = FirebaseStorage.Storage.storage().reference()
 let videoRef = storageRef.child("Videos/\(user.uid)/\(UUID().uuidString)")
 let metadata = StorageMetadata()
 metadata.contentType = "video/mp4"
 videoRef.putData(videoData, metadata: metadata) { (metadata, error) in
  if let error = error{
   completion(.failure(error))
  } else if let _ = metadata{
   print("video uploaded!")
   videoRef.downloadURL { (url, error) in
    // 1
    // attach video url to the artists subcollection called "videos"
    let documentRef = Firestore.firestore().collection("artists")
     .document(user.uid)
     .collection("videos")
     .document()
    Firestore.firestore().collection("artists")
     .document(user.uid)
     .collection("videos")
     .document(documentRef.documentID)
     .setData(["artistName" : "AXP Films",
          "videoUrl": url!.absoluteString]) { error in
           if let error = error {
            print("error: \(error)")
     }
    }
   }
  }
 }
}
}
