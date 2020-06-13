//
//  ProfileViewController.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet var profImage: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var bioLabel: UILabel!
    @IBOutlet public var tagsCollection: UICollectionView!
    @IBOutlet private var postsCollectionView: UICollectionView!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var addMediaButton: UIBarButtonItem!
    @IBOutlet private var likeArtistButton: UIButton!
    @IBOutlet private var chatButton: UIButton!
    @IBOutlet var infoView: DesignableView!
    
    let postCVDelegate = PostCollectionViewDelegate()
    let tagsCVDelegate = TagsCVDelegate()
    
    let db = DatabaseService()
    
    var artists = [Artist]() {
        didSet{
            print(artists.count)
        }
    }
    
    var singleArtist: Artist?
    
    var tags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getArtist()
        loadUI()
      
        infoView.borderColor = #colorLiteral(red: 0.3867273331, green: 0.8825651407, blue: 0.8684034944, alpha: 1)
        tagsCollection.delegate = tagsCVDelegate
        tagsCollection.dataSource = tagsCVDelegate
        tagsCollection.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tagCell")
        postsCollectionView.delegate = postCVDelegate
        postsCollectionView.dataSource = postCVDelegate
        postsCollectionView.register(UINib(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: "postCell")

        
    }
    
    private func loadUI() {
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        db.fetchArtist(userID: user.uid){ [weak self](result) in
            switch result {
            case.failure(let error):
                print(error.localizedDescription)
                
            case.success(let artist1):
                DispatchQueue.main.async {
                    self?.singleArtist = artist1
                    self?.nameLabel.text = artist1.name
                    self?.tags = artist1.tags
                }
             
            }
        }
        
        profImage.contentMode = .scaleAspectFill
        profImage.layer.cornerRadius = 60
        
          if user.photoURL == nil  {
                     profImage.image = UIImage(systemName: "person.fill")
                 } else {
                   profImage.kf.setImage(with: user.photoURL)
        }
//        nameLabel.text = singleArtist?.name
        
        
        
        emailLabel.text = user.email
        likeArtistButton.isHidden = true
        chatButton.isHidden = true
        
//        tags = singleArtist?.instruments ?? [""]
//        tags.append(contentsOf: singleArtist?.tags ?? [""])
//        print(tags)
    }
    
    
    func getArtist(){
       
        guard let userID = Auth.auth().currentUser?.uid else {
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
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadUI()
    }
    
   
    
    
    @IBAction func postVideoButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { (alertAction) in
            do {
                try Auth.auth().signOut()
            } catch {
                self.showAlert(title: "Error Signing Out", message: " \(error.localizedDescription)")
                
            }
            UIViewController.showViewController(storyboardName: "LoginView", viewControllerID: "LoginViewController")
        }
        let editProfAction = UIAlertAction(title: "Edit Profile", style: .default) { (alertAction) in
            //display edit vc
            let storyboard = UIStoryboard(name: "MainView", bundle: nil)
            let editProfVC = storyboard.instantiateViewController(withIdentifier: "EditProfController")
            self.navigationController?.show(editProfVC, sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(signOutAction)
        alertController.addAction(editProfAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        print(Auth.auth().currentUser?.email ?? "not current user because youre not logged in or signed up")
    }
    
    @IBAction func favArtistButtonPressed(_ sender: UIButton) {
        print("favorited")
    }
    
    
    @IBAction func chatButtonPressed(_ sender: UIButton) {
        print("chat")
    }
    
}
