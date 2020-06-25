//
//  ProfileViewViewModel.swift
//  InTune
//
//  Created by Tiffany Obi on 6/23/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

struct ProfileViewViewModel {
    private var database = DatabaseService()
    
    func fetchArtist(profileVC:ProfileViewController,user:User){
        
        database.fetchArtist(userID: user.uid){ [weak profileVC](result) in
            switch result {
            case.failure(let error):
                print(error.localizedDescription)
            case.success(let artist1):
                DispatchQueue.main.async {
                    profileVC?.singleArtist = artist1
                    profileVC?.nameLabel.text = artist1.name
                }
            }
        }
    }
        func getVideos(artist:Artist,profileVC:ProfileViewController){
            database.getVideo(artist: artist) {[weak profileVC] (result) in
              switch result {
              case .failure(let error):
                print(error)
              case .success(let videos):
                profileVC?.videos = videos
              }
            }
        }
    func loadUI(profileVC:ProfileViewController, user:User, singleArtist:Artist){
        profileVC.getVideos(artist: singleArtist)
        //        setUpEmptyViewForUser()
        profileVC.profImage.contentMode = .scaleAspectFill
       profileVC.profImage.layer.cornerRadius = 60
        if user.photoURL == nil  {
            profileVC.profImage.image = UIImage(systemName: "person.fill")
        } else {
            profileVC.profImage.kf.setImage(with: user.photoURL)
        }
        profileVC.locationLabel.text = user.email
        profileVC.likeArtistButton.isHidden = true
        profileVC.chatButton.isHidden = true
    }
    
    func loadExpUI(profileVC:ProfileViewController,artist:Artist){
        if let url = artist.photoURL{
            profileVC.profImage.kf.setImage(with: URL(string: url))
        }
        profileVC.likeArtistButton.isHidden = false
        profileVC.chatButton.isHidden = false
        profileVC.navigationItem.leftBarButtonItem = .none
        profileVC.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "exclamationmark.octagon.fill"), style: .plain, target: profileVC, action: #selector(profileVC.reportArtist(_:)))
        profileVC.navigationItem.rightBarButtonItem?.tintColor = .systemRed
        
        profileVC.getVideos(artist: artist)
        //        setUpEmptyViewFromExp()
        profileVC.isArtistInFav(artist: artist)
        profileVC.nameLabel.text = artist.name
        profileVC.locationLabel.text = artist.city
        
    }
    
    func setUpEmptyViewForUser(profileVC:ProfileViewController){
        guard let singleArtist = profileVC.singleArtist else {return}
        if singleArtist.isReported {
            let emptyView = EmptyView(message: "Your account has been reported !")
            profileVC.postsCollectionView.backgroundView = emptyView
            
        } else if profileVC.videos.count == 0 {
            profileVC.postsCollectionView.backgroundView = EmptyView(message: "Add New Videos !")
        } else {
            profileVC.postsCollectionView.backgroundView = nil
        }
    }
    
    func setUpEmptyViewFromExp(profileVC:ProfileViewController){
        guard let artist = profileVC.expArtist else { print("no expArtist")
            return
        }
        if artist.isReported {
            profileVC.likeArtistButton.isHidden = true
            profileVC.chatButton.isHidden = true
            profileVC.navigationItem.rightBarButtonItem = .none
            let emptyView = EmptyView(message: "This user has been reported !")
            profileVC.postsCollectionView.backgroundView = emptyView
        } else if profileVC.videos.count == 0 {
            profileVC.postsCollectionView.backgroundView = EmptyView(message: "No Posts Available")
        } else {
            profileVC.postsCollectionView.backgroundView = nil
        }
    }
    
    func isArtistInFav(artist:Artist, profileVC:ProfileViewController){
    database.isArtistInFav(for: artist) {[weak profileVC] (result) in
        switch result {
        case .failure(let error):
            print("try again: \(error.localizedDescription)")
        case .success(let status):
            if status {
                profileVC?.isArtistFavorite = true
            } else {
                
                profileVC?.isArtistFavorite = false
            }
        }
    }
}
   
    func deleteFavArtist(profileVC:ProfileViewController, expArtist:Artist, sender:UIButton){
        database.deleteFavArtist(for: expArtist) { [weak profileVC] (result) in
            switch result {
            case .failure(let error):
                print("could not delete from fav: \(error)")
            case .success:
                sender.setImage(UIImage(systemName: "music.note"), for: .normal)
                sender.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
                sender.imageView?.tintColor = #colorLiteral(red: 0.3429883122, green: 0.02074946091, blue: 0.7374325991, alpha: 1)
                profileVC?.isArtistFavorite = false
            }
    }
}
    func createFavArtist(profileVC:ProfileViewController,expArtist:Artist,sender:UIButton){
        database.createFavArtist(artist: expArtist) { [weak profileVC] (result) in
            switch result {
            case.failure(let error):
                profileVC?.showAlert(title: "Error", message: error.localizedDescription)
            case .success:
                sender.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
                sender.imageView?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                profileVC?.isArtistFavorite = true
            }
    }
}
    
    func checkReportStatus(profileVC:ProfileViewController,artist:Artist?) -> Int{
        guard let artist = artist else {return 0}
        if artist.isReported {
            return 0
        } else {
            return profileVC.videos.count
        }
    }
    
    func setUpReportArtist(profileVC:ProfileViewController,expArtist:Artist?){
       
    guard let artist = expArtist else {
            profileVC.navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
         let actionSheet = UIAlertController(title: "Report", message: "Are you sure you want to report this user?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let reportAction = UIAlertAction(title: "Report User", style: .destructive) { [weak profileVC](alertAction) in

        
            self.database.reportArtist(for: artist) { (result) in
                switch result {
                case .failure(let error):
                    profileVC?.showAlert(title: "Error", message: error.localizedDescription)
                case.success:
                    profileVC?.showAlert(title: "User Reported", message: "We have receieved your request and will review")
                }
            }
        }
        actionSheet.addAction(reportAction)
                actionSheet.addAction(cancelAction)
        profileVC.present(actionSheet, animated: true)
    }
    func setUpSettingsButton(profileVC:ProfileViewController,sender:UIBarButtonItem){
        
         let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
               let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { (alertAction) in
                   
                   profileVC.signOutAction(title: "Sign Out", message: "Are you sure you want to sign out?")
               }
               let editProfAction = UIAlertAction(title: "Edit Profile", style: .default) { (alertAction) in
                   //display edit vc
                   let storyboard = UIStoryboard(name: "MainView", bundle: nil)
                   let editProfVC = storyboard.instantiateViewController(withIdentifier: "EditProfController")
                   profileVC.navigationController?.show(editProfVC, sender: nil)
               }
               let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
               alertController.addAction(signOutAction)
               alertController.addAction(editProfAction)
               alertController.addAction(cancelAction)
        profileVC.present(alertController, animated: true)
               print(Auth.auth().currentUser?.email ?? "not current user because youre not logged in or signed up")
}
}


