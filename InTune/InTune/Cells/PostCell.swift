//
//  PostCell.swift
//  InTune
//
//  Created by Maitree Bain on 5/28/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
//    var experience = ExperienceView()
    
    func configureCell(vidURL: String) {
        guard let url = URL(string: vidURL) else { return }
        let imageInfo = url.videoPreviewThumbnail()
        cellImage.image = imageInfo
    }
    
    func configureCell(gigPost: GigsPost) {
//        let experience = Bundle.main.loadNibNamed("ExperienceView", owner: nil, options: nil)
//        experience.gigLocation.text = gigPost.location
//        experience.gigDate.text = gigPost.eventDate
//        experience.gigTitle.text = gigPost.title
        let label = UILabel()
        label.text = "gigs"
        label.center = center
        addSubview(label)
        label.backgroundColor = .yellow
    }
}
