//
//  TagCollectionViewCell.swift
//  InTune
//
//  Created by Maitree Bain on 5/29/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
        @IBOutlet weak var tagButton: UIButton!
        
        
        
        public var onButtonTapped: ((_ title:String) -> Void)?
        
        
        
        @IBAction func buttonTapped(_ sender: UIButton) {
            

        }
}

