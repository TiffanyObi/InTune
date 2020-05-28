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
    


