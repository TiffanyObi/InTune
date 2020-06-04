//
//  ChatsCell.swift
//  InTune
//
//  Created by Maitree Bain on 6/3/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class ChatsCell: UITableViewCell {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    func configureCell(for artist: Artist) {
        //use profImage here
        userNameLabel.text = artist.name
    }
}
