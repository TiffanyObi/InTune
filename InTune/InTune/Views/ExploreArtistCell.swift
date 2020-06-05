//
//  ExploreArtistCell.swift
//  InTune
//
//  Created by Maitree Bain on 6/5/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class ExploreArtistCell: UITableViewCell {
    
    public lazy var artistImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.fill")
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
    }

}
