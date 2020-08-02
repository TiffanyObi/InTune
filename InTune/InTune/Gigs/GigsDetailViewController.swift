//
//  GigsDetailViewController.swift
//  InTune
//
//  Created by Maitree Bain on 6/11/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class GigsDetailViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var postedByLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var descriptionText: UITextView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var messageButton: UIButton!
    
    var gigPost: GigsPost?
    
    
    var isGigInFavorite = false {
          didSet {
              if isGigInFavorite {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "bookmark.fill")
              } else {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "bookmark")
              }
          }
      }
    
    let db = DatabaseService()
    
    var singleArtist: Artist?
    var currentUser:Artist!
    
    func getArtist(){
        guard let userID = gigPost?.artistId else {
            return
        }
        db.fetchArtist(userID: userID){ [weak self](result) in
            switch result {
            case.failure(let error):
                print(error.localizedDescription)
                
            case.success(let artist1):
                self?.singleArtist = artist1
            }
        }
    }
    
    func getCurrentUser() {
        guard let user = Auth.auth().currentUser else { return}
        db.fetchArtist(userID: user.uid) { [weak self](result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
                
            case .success(let user):
                DispatchQueue.main.async {
                self?.currentUser = user
            }
        }
    }
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Details"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(favoriteButtonPressed(_:)))
        descriptionText.layer.cornerRadius = 14
        messageButton.shadowLayer(messageButton)
        getCurrentUser()
        getArtist()
        updateUI()
        setUpFavoriteButton()
    }
    
    func updateUI() {
        //set up image for profile + segue to prof
        guard let user = Auth.auth().currentUser else { return }
        guard let gig = gigPost else { return }
        if gig.artistId == user.uid {
            navigationItem.rightBarButtonItem = nil
            messageButton.isHidden = true
        }
        titleLabel.text = gig.title
        //        guard let imageurl = gig.imageURL else { return }
        //        guard let url = URL(string: imageurl) else { return }
        //        postImage.kf.setImage(with: url)
        locationLabel.text = "Location: \(gig.location)"
        dateLabel.text = gig.eventDate
        postedByLabel.text = gig.artistName
        priceLabel.text = "$\(gig.price)"
        descriptionText.text = gig.descript
    }
    
    func setUpFavoriteButton() {
        guard let gig = gigPost else { return }
        db.isGigInFav(favGig: gig) { (result) in
            switch result  {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            case .success(let success):
                if success {
                    self.isGigInFavorite = true
                } else {
                    self.isGigInFavorite = false
                }
            }
        }
    }
    
  
    
    @objc func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        guard let gig = gigPost else { return }
        if isGigInFavorite {
            db.unfavoriteGig(for: gig) { (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                case .success:
                    DispatchQueue.main.async {
                        self.showAlert(title: "Gig removed", message: nil)
                        self.isGigInFavorite = false
                    }
                }
            }
        } else {
            guard let gig = gigPost else { return }
            db.favoriteGig(artist: currentUser , gigPost: gig) { (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(title: "Favoriting error", message: error.localizedDescription)
                    }
                case .success:
                    DispatchQueue.main.async {
                        self.showAlert(title: "Gig Favorited", message: nil)
                        self.isGigInFavorite = true
                    }
                }
            }
        }
    }
    
    
    @IBAction func messageButtonPressed(_ sender: UIButton) {
        let chatVC = ChatViewController()
        chatVC.artist = singleArtist
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
}
