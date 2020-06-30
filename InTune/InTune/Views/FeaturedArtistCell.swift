//
//  FeaturedArtistCell.swift
//  InTune
//
//  Created by Maitree Bain on 6/5/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import Kingfisher

class FeaturedArtistCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    public func configureCell(artistPhotoURL: String?){
        if let photoURL = artistPhotoURL, let url = URL(string: photoURL){
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(systemName: "person.fill")
        }
    }
    
}
