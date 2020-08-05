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
}
