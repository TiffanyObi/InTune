//
//  TagCollectionViewCell.swift
//  InTune
//
//  Created by Maitree Bain on 5/29/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

protocol TagsCVDelegate:AnyObject {
    func updateUserPreferences(_ cell:TagCollectionViewCell,instrument:String,genre:String)
}

class TagCollectionViewCell: UICollectionViewCell {
    
        
    @IBOutlet weak var tagTitle: UILabel!
    
    @IBOutlet weak var checkButton: UIButton!
    
    var instrument = ""
    var genre = ""
    weak var tagsDelegate: TagsCVDelegate?
    var isButtonPressed: (() -> Void)?
    
    static let cellIdentifier = "tagCell"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
        
        tagTitle.layer.cornerRadius = 10.0
        tagTitle.layer.masksToBounds = true
        
        checkButton.layer.cornerRadius = 10.0
        checkButton.layer.masksToBounds = true
    }
    
    func configureWithModel(_ model: TagCollectionViewCellModel) {
        tagTitle.text = model.name
        instrument = model.name
        
        if model.isSelected {
            checkButton.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
        } else {
            checkButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
        }
    }
    
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        checkButton.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
        
        isButtonPressed?()
        tagsDelegate?.updateUserPreferences(self, instrument: instrument, genre: genre)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        checkButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
    }

}
