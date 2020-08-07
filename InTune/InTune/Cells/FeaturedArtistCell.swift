//
//  FeaturedArtistCell.swift
//  InTune
//
//  Created by Oscar Victoria Gonzalez  on 7/19/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import Kingfisher

class FeaturedArtistCell: UICollectionViewCell {

    @IBOutlet weak var artistImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        artistImageView.tintColor = .systemGray5
    }
    
    
    public func configureCell(artistPhotoURL: String?) {
          if let photoURL = artistPhotoURL, let url = URL(string: photoURL){
                          artistImageView.kf.setImage(with: url)
            
          } else {
            artistImageView.contentMode = .scaleAspectFit
              artistImageView.image = UIImage(systemName: "person.fill")
          }
      }
    
}
