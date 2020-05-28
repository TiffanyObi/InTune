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
    
    @IBOutlet weak var profImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var tagsCollection: UICollectionView!
    @IBOutlet weak var postsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        tagsCollection.delegate = self
//        tagsCollection.dataSource = self
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        postsCollectionView.register(UINib(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: "postCell")
    }
    
    private func dummyProf() {
        
        guard let user = Auth.auth().currentUser, let email = user.email else {
            return
        }
        
        nameLabel.text = "\(email)"
    }
    
    private func collectionView() {

    }
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        
        do {
                try Auth.auth().signOut()
            } catch {
                self.showAlert(title: "Error Signing Out", message: " \(error.localizedDescription)")
                
            }
            UIViewController.showViewController(storyboardName: "LoginView", viewControllerID: "LoginViewController")
            
            print(Auth.auth().currentUser?.email ?? "not current user because youre not logged in or signed up")
        }
    }
    


extension ProfileViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.40
      let itemHeight: CGFloat = maxSize.height * 0.20
      return CGSize(width: itemWidth, height: itemHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? PostCell else {
            fatalError("could not conform to postCell")
        }
        
        return cell
    }
    
    
}