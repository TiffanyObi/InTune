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
    public func configureFavArtistCell(favArtist: FavoritedArtist){
        if let url = favArtist.favPhotoURL, let imageURL = URL(string: url){
            imageView.kf.setImage(with: imageURL)
        }
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
                if let post = posts.first {
                    
                    if post.artistId == artist.favArtistID{
                        self?.statusButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
                        self?.postStatusLabel.text = "New Post: \(post.title)\""
                    }
                } else {
                    self?.postStatusLabel.text = "No recent posts"
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        displayNameLabel.text = nil
        locationLabel.text = nil
        postStatusLabel.text = nil
        statusButton.setImage(UIImage(systemName: "circle"), for: .normal)
    }
}
