//
//  ChatsCell.swift
//  InTune
//
//  Created by Maitree Bain on 6/3/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatsCell: UITableViewCell {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    func configureCell(for artist: Artist) {
        if let urlString = artist.photoURL, let url = URL(string: urlString) {
            userImage.kf.setImage(with: url)
        } else {
            userImage.image = UIImage(systemName: "person.crop.square")
        }
        userNameLabel.text = artist.name
        messageLabel.text = "Location: \(artist.city)"
//        if let message = message {
//            messageLabel.text = "\(message.content)"
//        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
}
