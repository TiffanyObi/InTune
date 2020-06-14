//
//  ProfileViewController.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseAuth

enum Segue {
    case explore
    case prof
}

class ProfileViewController: UIViewController {
    
    @IBOutlet var profImage: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var bioLabel: UILabel!
    @IBOutlet public var tagsCollection: UICollectionView!
    @IBOutlet private var postsCollectionView: UICollectionView!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var addMediaButton: UIBarButtonItem!
    @IBOutlet var likeArtistButton: UIButton!
    @IBOutlet var chatButton: UIButton!
    @IBOutlet var postVidButton: UIBarButtonItem!
    @IBOutlet var settingsButton: UIBarButtonItem!
    @IBOutlet var infoView: DesignableView!
    
    let postCVDelegate = PostCollectionViewDelegate()
    let tagsCVDelegate = TagsCVDelegate()
    
    let db = DatabaseService()
    
    var singleArtist: Artist? {
        didSet {
            tagsCollection.reloadData()
        }
    }
    
    var expArtist: Artist?
    
    var state: Segue = .prof
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getArtist()
        infoView.borderColor = #colorLiteral(red: 0.3867273331, green: 0.8825651407, blue: 0.8684034944, alpha: 1)
        tagsCollection.delegate = self
        tagsCollection.dataSource = self
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

        locationLabel.text = user.email
        likeArtistButton.isHidden = true
        chatButton.isHidden = true
    }
    
    func loadExpUI() {
        likeArtistButton.isHidden = false
        chatButton.isHidden = false
        navigationItem.leftBarButtonItem = .none
        navigationItem.rightBarButtonItem = .none
        guard let artist = expArtist else { print("no expArtist")
            return
        }
        nameLabel.text = artist.name
        locationLabel.text = artist.city
        
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
        if state == .prof{
        loadUI()
        } else {
            loadExpUI()
        }
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
        
        guard let expArtist1 = expArtist else { return}
        
        db.createFavoriteArtist(artist: expArtist1) { (result) in
            switch result {
            case.failure(let error):
                print(error.localizedDescription)
                
            case .success:
                print(true)
            }
        }
    }
    
    
    @IBAction func chatButtonPressed(_ sender: UIButton) {
        print("chat")
        let chatVC = ChatViewController()
        chatVC.artist = expArtist
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.20
        let itemHeight: CGFloat = maxSize.height * 0.30
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return singleArtist?.tags.count ?? 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as? TagCollectionViewCell else {
            fatalError("could not conform to TagCell")
        }
        
    
        
        if state == .prof {
            let tag = singleArtist?.tags[indexPath.row]
             cell.configureCell(tag ?? "no tags")
        } else if state == .explore {
            let tag = expArtist?.tags[indexPath.row]
             cell.configureCell(tag ?? "no tags")
        }
        
        
        return cell
}
}
