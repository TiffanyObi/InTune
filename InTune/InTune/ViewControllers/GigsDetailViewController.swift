//
//  GigsDetailViewController.swift
//  InTune
//
//  Created by Maitree Bain on 6/11/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class GigsDetailViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var postedByLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var descriptionText: UITextView!
    
    var gigPost: GigsPost?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    func updateUI() {
        //set up image for profile + segue to prof
        guard let gig = gigPost else { return }
        titleLabel.text = gig.title
//        guard let imageurl = gig.imageURL else { return }
//        guard let url = URL(string: imageurl) else { return }
//        postImage.kf.setImage(with: url)
        dateLabel.text = gig.eventDate
        postedByLabel.text = gig.artistName
        priceLabel.text = "$\(gig.price)"
        descriptionText.text = gig.descript
    }
    

}
