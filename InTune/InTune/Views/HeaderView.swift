//
//  HeaderView.swift
//  InTune
//
//  Created by Maitree Bain on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
        
    @IBOutlet weak var favoriteArtistButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    @IBAction func favoriteArtistButtonPressed(_ sender: UIButton) {
        print("favorite")
    }
    
    @IBAction func chatButtonPressed(_ sender: UIButton) {
        print("chat")
    }
}
