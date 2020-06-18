//
//  GigCell.swift
//  InTune
//
//  Created by Maitree Bain on 6/11/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import Kingfisher

class GigCell: UITableViewCell {
    
    @IBOutlet weak var gigImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    public func configureGig(for gig: GigsPost) {
        titleLabel.text = gig.title.uppercased()
        dateLabel.text = "Date: \(gig.eventDate)"
        locationLabel.text = "Location: \(gig.location)"
    }
    
}
