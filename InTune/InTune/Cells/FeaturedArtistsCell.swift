//
//  FeaturedArtistsCell.swift
//  InTune
//
//  Created by Oscar Victoria Gonzalez  on 7/17/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import Kingfisher

class FeaturedArtistsCell: UICollectionViewCell {
    
    static let identifier = "artistsCell"
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 90.0/2.0
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(myImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        myImageView.frame = contentView.bounds
    }
    
   public func configureCell(artistPhotoURL: String?){
       if let photoURL = artistPhotoURL, let url = URL(string: photoURL){
           myImageView.kf.setImage(with: url)
       } else {
           myImageView.image = UIImage(systemName: "person.fill")
       }
   }
    
    
    
   
    
    
 
    
        
}

    

