//
//  TagCollectionViewCell.swift
//  InTune
//
//  Created by Maitree Bain on 5/29/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
        
    @IBOutlet weak var tagTitle: UILabel!
    
    @IBOutlet weak var checkButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
         
      
    }
    
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        checkButton.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
//        checkButton.imageView?.tintColor = .purple
    }
    
    func configureCell(_ tag:String) {
        
        
        if Tags.instrumentList.contains(tag){
            tagTitle.text = tag
            tagTitle.backgroundColor = .purple
        } else if Tags.genreList.contains(tag){
        tagTitle.text = tag
            tagTitle.backgroundColor = .systemTeal
    }
}

}
