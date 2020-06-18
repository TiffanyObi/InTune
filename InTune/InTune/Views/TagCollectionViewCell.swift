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
            tagTitle.backgroundColor = .black
            tagTitle.textColor = .white
            tagTitle.text = tag
        } else if Tags.genreList.contains(tag){
            tagTitle.backgroundColor = #colorLiteral(red: 0.3429883122, green: 0.02074946091, blue: 0.7374325991, alpha: 1)
            tagTitle.textColor = .white
            tagTitle.text = tag
    }
}

}
