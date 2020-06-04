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
    
    @IBOutlet private var profImage: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var bioLabel: UILabel!
    @IBOutlet private var tagsCollection: UICollectionView!
    @IBOutlet private var postsCollectionView: UICollectionView!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var cameraButton: UIBarButtonItem!
    @IBOutlet private var likeArtistButton: UIButton!
    @IBOutlet private var chatButton: UIButton!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
        let pickerController = UIImagePickerController()
        pickerController.mediaTypes = mediaTypes ?? ["kUTTypeImage"]
        pickerController.delegate = self
        return pickerController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = false
        }
        //        tagsCollection.delegate = self
        //        tagsCollection.dataSource = self
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        postsCollectionView.register(UINib(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: "postCell")
        loadUI()
    }
    
    private func loadUI() {
        
        
        guard let user = Auth.auth().currentUser, let email = user.email else {
            return
        }
        
        emailLabel.text = "\(email)"
        likeArtistButton.isHidden = true
        chatButton.isHidden = true
    }
    
    private func collectionView() {
        
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
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true)
        
    }
    
    
    @IBAction func favArtistButtonPressed(_ sender: UIButton) {
        print("favorited")
    }
    
    
    @IBAction func chatButtonPressed(_ sender: UIButton) {
        print("chat")
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? PostCell else {
            fatalError("could not conform to postCell")
        }
        
        return cell
    }
    
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else  {
            return
        }
        
        switch mediaType {
        case "public.image":
            print("image picked")
        case "public.movie":
            print("video picked")
        default:
            print("default")
        }
    }
}
