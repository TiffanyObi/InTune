//
//  FeaturedArtistCell.swift
//  InTune
//
//  Created by Maitree Bain on 6/5/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class FeaturedArtistCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    public func configureCell(placeHolderImage: String){
        imageView.image = UIImage(named: placeHolderImage)
    }
}
