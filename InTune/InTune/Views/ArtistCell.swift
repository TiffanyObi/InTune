//
//  ArtistCell.swift
//  InTune
//
//  Created by Tiffany Obi on 6/4/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import Kingfisher

class ArtistCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var statusButton: UIButton!
    @IBOutlet var postStatusLabel: UILabel!
    
    let db = DatabaseService()
    public func configureFavArtistCell(favArtist:FavoritedArtist){
        imageView.image = UIImage(systemName: "photo.fill")
        statusButton.isHidden = true
        displayNameLabel.text = favArtist.favArtistName
        locationLabel.text = favArtist.favArtistLocation
        getArtistGigPosts(artist: favArtist)
        
    }
    
    func getArtistGigPosts(artist:FavoritedArtist){
        db.getLikedArtistGigPosts(likedArtist: artist) {[weak self] (result) in
            switch result {
            case .failure:
                self?.postStatusLabel.text = "No recent posts"
                
            case .success(let posts):
                guard let post = posts.first else {return}
                self?.postStatusLabel.text = "Most Recent Post: \" \(post.title)\""
            }
        }
    }
    
}
