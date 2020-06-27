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
    
    func configureCell(for artist: Artist, _ message: Message?) {
        
        if let photoURL = artist.photoURL, let url = URL(string: photoURL) {
            userImage.kf.setImage(with: url)
        }
        userNameLabel.text = artist.name
        
        if let message = message {
            messageLabel.text = message.content
        } 
    }
}
