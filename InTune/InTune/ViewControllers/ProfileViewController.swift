//
//  ProfileViewController.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import AVKit
import FirebaseFirestore

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
    
    
    let db = DatabaseService()
    
    var singleArtist: Artist? {
        didSet {
            tagsCollection.reloadData()
        }
    }
    var expArtist: Artist?
    
    var isArtistFavorite = false {
        didSet {
            if isArtistFavorite {
                likeArtistButton.setImage(UIImage(systemName: "person.crop.circle.fill.badge.minus"), for: .normal)
            } else {
                likeArtistButton.setImage(UIImage(systemName: "person.crop.circle.badge.plus"), for: .normal)
            }
        }
    }
    
    var state: Segue = .prof
    
    var videos = [Video](){
        didSet{
            postsCollectionView.reloadData()
        }
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getArtist()
        infoView.borderColor = #colorLiteral(red: 0.3867273331, green: 0.8825651407, blue: 0.8684034944, alpha: 1)
        tagsCollection.delegate = self
        tagsCollection.dataSource = self
        tagsCollection.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tagCell")
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
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
        
        guard let singleArtist = singleArtist else {return}
        if singleArtist.isReported {
                let emptyView = EmptyView(message: "Your account has been reported !")
            
            postsCollectionView.backgroundView = emptyView
            
        }
        getVideos(artist: singleArtist)
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "exclamationmark.octagon.fill"), style: .plain, target: self, action: #selector(reportArtist(_:)))
        guard let artist = expArtist else { print("no expArtist")
            return
        }
        if artist.isReported {
            likeArtistButton.isHidden = true
            chatButton.isHidden = true
            let emptyView = EmptyView(message: "This user has been reported !")
            postsCollectionView.backgroundView = emptyView
        }
        getVideos(artist: artist)
        isArtistInFav(artist: artist)
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
    
    func getVideos(artist:Artist){
        db.getVideo(artist: artist) { (result) in
        switch result {
        case .failure(let error):
          print(error)
        case .success(let videos):
          self.videos = videos
        }
      }
    }
    
    @objc func reportArtist(_ sender: UIBarButtonItem){
        guard let artist = expArtist else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        db.reportArtist(for: artist) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case.success:
                print(true)
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
        guard let expArtist = expArtist else { return }
        
        if isArtistFavorite {
            isArtistInFav(artist: expArtist)
            db.deleteFavArtist(for: expArtist) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    print("could not delete from fav: \(error)")
                case .success:
                    sender.setImage(UIImage(systemName: "person.crop.circle.fill.badge.plus"), for: .normal)
                    self?.isArtistFavorite = false
                }
            }
        } else {
            db.createFavArtist(artist: expArtist) { [weak self] (result) in
                switch result {
                case.failure(let error):
                    print(error.localizedDescription)
                case .success:
                    sender.setImage(UIImage(systemName: "person.crop.circle.badge.minus"), for: .normal)
                    self?.isArtistFavorite = true
                }
            }
        }
    }
    private func isArtistInFav(artist:Artist){
        db.isArtistInFav(for: artist) {[weak self] (result) in
            switch result {
            case .failure(let error):
                print("try again: \(error.localizedDescription)")
            case .success(let status):
                if status {
                    self?.isArtistFavorite = true
                } else {
                    
                    self?.isArtistFavorite = false
                }
            }
        }
    }
    @IBAction func chatButtonPressed(_ sender: UIButton) {
        let chatVC = ChatViewController()
        chatVC.artist = expArtist
        navigationController?.pushViewController(chatVC, animated: true)
    }
}




extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
       
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == tagsCollection {
            if state == .prof {
            return singleArtist?.tags.count ?? 3
        } else {
            return expArtist?.tags.count ?? 2
        }
    }
        
        if collectionView == postsCollectionView {
            if state == .prof {
                if singleArtist?.isReported ?? true {
                    return 0
                } else {
                return videos.count
            }
        }else {
                if expArtist?.isReported ?? true {
                    return 0
                } else {
                return videos.count 
            }
        }

    }
        return 0
}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == tagsCollection {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as? TagCollectionViewCell else {
            fatalError("could not downcast to TagCollectionViewCell")
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
        if collectionView == postsCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? PostCell else {
                fatalError("could not conform to TagCell")
                }
            if state == .prof {
                let video = videos[indexPath.row]
                print(video.urlString ?? "")
                if let urlString = video.urlString {
                cell.configureCell(vidURL: urlString)
                }
            } else if state == .explore {
                let video = videos[indexPath.row]
                print(video.urlString ?? "")
                if let urlString = video.urlString {
                cell.configureCell(vidURL: urlString)
                }
            }
            
            return cell
        }
          return UICollectionViewCell()
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
           if collectionView == tagsCollection {
           let maxSize: CGSize = UIScreen.main.bounds.size
           let itemWidth: CGFloat = maxSize.width * 0.20
           let itemHeight: CGFloat = maxSize.height * 0.30
           return CGSize(width: itemWidth, height: itemHeight)
           }
           
           if collectionView == postsCollectionView {
              
                   let maxSize: CGSize = UIScreen.main.bounds.size
                   let itemWidth: CGFloat = maxSize.width * 0.55
                   let itemHeight: CGFloat = maxSize.height * 0.25
                   return CGSize(width: itemWidth, height: itemHeight)
               }
            return CGSize(width: 0.5, height: 0.5)
           }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          // get video selected at n index
          let video = videos[indexPath.row]
          // create av player vc
          let playController = AVPlayerViewController()
          guard let urlStr = video.urlString else { return }
          let player = AVPlayer(url: URL(string: urlStr)!)
          //present av vc
          playController.player = player
          present(playController, animated: true) {
            player.play()
          }
        }
    }


