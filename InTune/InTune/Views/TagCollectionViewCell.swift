//
//  TagCollectionViewCell.swift
//  InTune
//
//  Created by Maitree Bain on 5/29/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

protocol TagsCVDelegate:AnyObject {
    func updateUserPreferences(_ isPicked:Bool,_ cell:TagCollectionViewCell,instrument:String,genre:String)
}

class TagCollectionViewCell: UICollectionViewCell {
    
        
    @IBOutlet weak var tagTitle: UILabel!
    
    @IBOutlet weak var checkButton: UIButton!
    
    var isPicked: Bool = false
    var instrument = ""
    var genre = ""
    weak var tagsDelegate: TagsCVDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
         
      
    }
    
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        checkButton.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
        
        isPicked = true
        tagsDelegate?.updateUserPreferences(isPicked, self, instrument: instrument, genre: genre)
    }
    
    func configureCell(_ tag:String) {
        
        if Tags.instrumentList.contains(tag){
            tagTitle.text = tag
            self.layer.cornerRadius = 30
            tagTitle.backgroundColor = .purple
        } else if Tags.genreList.contains(tag){
        tagTitle.text = tag
            self.layer.cornerRadius = 30
            tagTitle.backgroundColor = .systemTeal
    }
}

}
