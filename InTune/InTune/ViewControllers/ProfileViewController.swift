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
    @IBOutlet public var nameLabel: UILabel!
    @IBOutlet private var bioLabel: UILabel!
    @IBOutlet public var tagsCollection: UICollectionView!
    @IBOutlet public var postsCollectionView: UICollectionView!
    @IBOutlet public var locationLabel: UILabel!
    @IBOutlet private var addMediaButton: UIBarButtonItem!
    @IBOutlet var likeArtistButton: UIButton!
    @IBOutlet var chatButton: UIButton!
    @IBOutlet var postVidButton: UIBarButtonItem!
    @IBOutlet var settingsButton: UIBarButtonItem!
    @IBOutlet var infoView: DesignableView!
    
    private lazy var longPress: UILongPressGestureRecognizer = {
       let press = UILongPressGestureRecognizer()
        press.addTarget(self, action: #selector(deletePost(_:)))
        return press
    }()
    
    let db = DatabaseService()
    
    var singleArtist: Artist? {
        didSet {
            tagsCollection.reloadData()
        }
    }
    let profileViewModel = ProfileViewViewModel()
    var expArtist: Artist?
    
    var isArtistFavorite = false {
        didSet {
            if isArtistFavorite {
                likeArtistButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                likeArtistButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    
    var state: Segue = .prof
    
    var videos = [Video](){
        didSet{
            postsCollectionView.reloadData()
            setUpEmptyViewForUser()
            setUpEmptyViewFromExp()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getArtist()
        loadUI()
        self.navigationController?.navigationBar.tintColor = .black
        infoView.borderColor = #colorLiteral(red: 0.3867273331, green: 0.8825651407, blue: 0.8684034944, alpha: 1)
        tagsCollection.delegate = self
        tagsCollection.dataSource = self
        tagsCollection.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tagCell")
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        postsCollectionView.layer.cornerRadius = 14
        postsCollectionView.register(UINib(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: "postCell")
        postsCollectionView.addGestureRecognizer(longPress)
        profileViewModel.setUpLikeButton(profileVC: self, button: likeArtistButton)
    }
    
    
    private func loadUI() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        profileViewModel.fetchArtist(profileVC: self, user: user)
        guard let singleArtist = singleArtist else {return}
        getVideos(artist: singleArtist)
        profImage.contentMode = .scaleAspectFill
        if user.photoURL == nil  {
            profImage.image = UIImage(systemName: "person.fill")
        } else {
            profImage.kf.setImage(with: user.photoURL)
        }
        if singleArtist.bioText == nil {
            bioLabel.text = "Under Construction"
        } else {
            bioLabel.text = singleArtist.bioText
        }
        locationLabel.text = user.email
        likeArtistButton.isHidden = true
        chatButton.isHidden = true

        
        profileViewModel.loadUI(profileVC: self, user: user, singleArtist: singleArtist)

    }
    
    func loadExpUI() {
        guard let artist = expArtist else { print("no expArtist")
            return
        }
        profileViewModel.loadExpUI(profileVC: self, artist: artist)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if state == .prof{
            loadUI()
        } else {
            loadExpUI()
        }
    }
    
    func getArtist(){
        guard let user = Auth.auth().currentUser else {
            return
        }
        profileViewModel.fetchArtist(profileVC: self, user: user)
    }
    func getVideos(artist:Artist){
        profileViewModel.getVideos(artist: artist, profileVC: self)
    }
    
    func setUpEmptyViewForUser(){
        profileViewModel.setUpEmptyViewForUser(profileVC: self)
    }
    func setUpEmptyViewFromExp(){
        profileViewModel.setUpEmptyViewFromExp(profileVC: self)
    }
    @objc func reportArtist(_ sender: UIBarButtonItem){
        
profileViewModel.setUpReportArtist(profileVC: self, expArtist: expArtist)
    }
    
    @objc func deletePost(_ gesture: UILongPressGestureRecognizer) {
        let alert = UIAlertController(title: nil, message:  nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (alertAction) in
            //call delete post here
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
       
    @IBAction func postVideoButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
profileViewModel.setUpSettingsButton(profileVC: self, sender: sender)

    }
    
    @IBAction func favArtistButtonPressed(_ sender: UIButton) {
        guard let expArtist = expArtist else { return }
        if isArtistFavorite {
            isArtistInFav(artist: expArtist)

profileViewModel.deleteFavArtist(profileVC: self, expArtist: expArtist, sender: sender)
        } else {
    profileViewModel.createFavArtist(profileVC: self, expArtist: expArtist, sender: sender)
            }
    }

    public func isArtistInFav(artist:Artist){
        profileViewModel.isArtistInFav(artist: artist, profileVC: self)
    }
    
    @IBAction func chatButtonPressed(_ sender: UIButton) {
        let chatVC = ChatViewController()
        chatVC.artist = expArtist
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == postsCollectionView {
            cell.colorShadow(for: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
    }
    
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
                return profileViewModel.checkReportStatus(profileVC: self, artist: singleArtist)
            } else {
                return profileViewModel.checkReportStatus(profileVC: self, artist: expArtist)
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
                if let urlString = video.urlString {
                    cell.configureCell(vidURL: urlString)
                }
            } else if state == .explore {
                let video = videos[indexPath.row]
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
            let itemWidth: CGFloat = maxSize.width * 0.415
            let itemHeight: CGFloat = maxSize.height * 0.20
            return CGSize(width: itemWidth, height: itemHeight)
        }
        return CGSize(width: 0.5, height: 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 25, left: 5, bottom: 25, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // get video selected at n index
        if collectionView == postsCollectionView{
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
        
        //long press
    }
}


