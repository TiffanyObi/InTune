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
    @IBOutlet public var bioLabel: UILabel!
    @IBOutlet public var tagsCollection: UICollectionView!
    @IBOutlet public var postsCollectionView: UICollectionView!
    @IBOutlet public var locationLabel: UILabel!
    @IBOutlet var addMediaButton: UIBarButtonItem!
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
    let storageService = StorageService()
    
    var singleArtist: Artist? {
        didSet {
            tagsCollection.reloadData()
        }
    }
    
    var postsListener: ListenerRegistration?
    
    let profileViewModel = ProfileViewViewModel()
    let experienceView = ExperienceCell()
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
    
    var isAnArtist: Bool? {
        didSet {
            postsCollectionView.reloadData()
        }
    }
    
    var gigs = [GigsPost]() {
        didSet{
            postsCollectionView.reloadData()
        }
    }
    
    var videos = [Video](){
        didSet{
            postsCollectionView.reloadData()
            setUpEmptyViewForUser()
            setUpEmptyViewFromExp()
        }
    }
    
    var vid: Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getArtist()
        self.navigationController?.navigationBar.tintColor = .black
        infoView.borderColor = #colorLiteral(red: 0.3867273331, green: 0.8825651407, blue: 0.8684034944, alpha: 1)
        tagsCollection.delegate = self
        tagsCollection.dataSource = self
        tagsCollection.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tagCell")
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        postsCollectionView.layer.cornerRadius = 14
        postsCollectionView.register(UINib(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: "postCell")
        postsCollectionView.register(UINib(nibName: "ExperienceCell", bundle: nil), forCellWithReuseIdentifier: "expCell")
        profileViewModel.setUpLikeButton(profileVC: self, button: likeArtistButton)
    }
    
    private func setProfileViewState(){
        if state == .prof {
            loadUI()
        } else {
            loadExpUI()
        }
        postsCollectionView.reloadData()
    }
    
    private func loadUI() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        profileViewModel.fetchArtist(profileVC: self, userID: user.uid)
        likeArtistButton.isHidden = true
        chatButton.isHidden = true
    }
    
    func loadExpUI() {
        guard let artist = expArtist else {
            print("no expArtist")
            return
        }
        profileViewModel.loadExpUI(profileVC: self, artist: artist)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setProfileViewState()
    }
    
    func getArtist(){
        if state == .prof {
            guard let user = Auth.auth().currentUser else {
                return
            }
            profileViewModel.fetchArtist(profileVC: self, userID: user.uid)
        } else {
            guard let expArtist = expArtist else { return }
            profileViewModel.fetchArtist(profileVC: self, userID: expArtist.artistId)
        }
    }
    func getVideos(artist:Artist){
        profileViewModel.getVideos(artist: artist, profileVC: self)
        
    }
    
    func getGigs(artist: Artist){
        profileViewModel.getGigPosts(profileVC: self)
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
            self.deletePost()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    private func deletePost() {
        guard let video = vid else {
            print("no vid found")
            return }
        db.deleteVideoPost(post: video) { [weak self] (result) in
            
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error deleting post", message: "\(error.localizedDescription)")
                }
            case .success:
                self!.deleteStorage()
            }
        }
    }
    
    func deleteStorage() {
        guard let video = vid else {
            print("no vid found")
            return }
        
        storageService.deleteVideo(vid: video) { (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Could not delete video", message: error.localizedDescription)
                }
            case .success:
                DispatchQueue.main.async {
                    self.showAlert(title: "Video Deleted", message: nil)
                    self.postsCollectionView.reloadData()
                }
            }
        }
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
                fatalError("could not conform to postCell")
            }
            
            switch state {
            case .explore:
                let video = videos[indexPath.row]
                vid = video
                if let urlString = video.videoUrl {
                    cell.configureCell(vidURL: urlString)
                }
            case .prof:
                if isAnArtist ?? false {
                    cell.addGestureRecognizer(longPress)
                    let video = videos[indexPath.row]
                    vid = video
                    if let urlString = video.videoUrl {
                        cell.configureCell(vidURL: urlString)
                    }
                } else {
                    guard let expCell = collectionView.dequeueReusableCell(withReuseIdentifier: "expCell", for: indexPath) as? ExperienceCell else {
                        fatalError("could not conform to expCell")
                    }
                    let post = gigs[indexPath.row]
                    expCell.configureCell(for: post)
                    
                    return expCell
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
            
            if isAnArtist ?? false {
            let maxSize: CGSize = UIScreen.main.bounds.size
            let itemWidth: CGFloat = maxSize.width * 0.415
            let itemHeight: CGFloat = maxSize.height * 0.20
            return CGSize(width: itemWidth, height: itemHeight)
            } else {
                let maxSize: CGSize = UIScreen.main.bounds.size
                let itemWidth: CGFloat = maxSize.width * 0.8
                let itemHeight: CGFloat = maxSize.height * 0.16
                return CGSize(width: itemWidth, height: itemHeight)
            }
        }
        return CGSize(width: 0.5, height: 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // get video selected at n index
        if collectionView == postsCollectionView{
            if isAnArtist ?? true {
                let video = videos[indexPath.row]
                // create av player vc
                let playController = AVPlayerViewController()
                guard let urlStr = video.videoUrl else { return }
                let player = AVPlayer(url: URL(string: urlStr)!)
                //present av vc
                playController.player = player
                present(playController, animated: true) {
                    player.play()
                }
            } else {
                let storyBoard = UIStoryboard(name: "GigsView", bundle:  nil)
                guard let detailVC = storyBoard.instantiateViewController(identifier: "GigsDetailViewController") as? GigsDetailViewController else {
                    fatalError("could not load gigsDetail")
                }
                let gig = gigs[indexPath.row]
                detailVC.gigPost = gig
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
}


