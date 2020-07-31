//
//  ExperienceView.swift
//  InTune
//
//  Created by Maitree Bain on 7/21/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class ExperienceCell: UICollectionViewCell {
    
    @IBOutlet var gigImage: UIImageView!
    @IBOutlet var gigTitle: UILabel!
    @IBOutlet var gigDate: UILabel!
    @IBOutlet var gigLocation: UILabel!
    
    func configureCell(for post: GigsPost) {
        gigImage.image = UIImage(named: "newPost")
        gigTitle.text = "\(post.title)"
        gigDate.text = "Event date: \(post.eventDate)"
        gigLocation.text = "Location: \(post.location)"
    }
}
