//
//  ExploreViewController.swift
//  InTune
//
//  Created by Tiffany Obi on 5/26/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ExploreViewController: UIViewController {
    
    @IBOutlet private var tagsCollectionView: UICollectionView!
    @IBOutlet private var artistTableView: UITableView!
    @IBOutlet private var featuredArtistCV: UICollectionView!
    
    let tabsCVDelegate = TagsCVDelegate()
    let featuredCVDelegate = FeaturedArtistCVDelegate()
    
    let db = DatabaseService()
    var listener: ListenerRegistration?
    
    var artists = [Artist](){
        didSet{
            DispatchQueue.main.async {
                self.artistTableView.reloadData()
            }
        }
    }
    
    
    var currentUser: Artist?
    var featuredArtistPlaceHolderImages = ["singer","tatMan","tLuke","trio","violinist"]
    
    var tags = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.tagsCollectionView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard let expEdit = segue.destination as? ExploreOptionsController else {
                fatalError("could not segue to ExploreOptionsController ")
            }
        expEdit.prefDelegate = self
        }
    
    let height: CGFloat = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArtists()
        getCurrentUserPref()
        tagsCollectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tagCell")
        artistTableView.register(ExploreArtistCell.self, forCellReuseIdentifier: "exploreCell")
        featuredArtistCV.register(UINib(nibName: "FeaturedArtist", bundle: nil), forCellWithReuseIdentifier: "featuredArtist")
        setUpCVs()
        setUpTV()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        guard let currentUser1 = currentUser else { return }
        
        listener = Firestore.firestore().collection(DatabaseService.artistsCollection).document(currentUser1.artistId).addSnapshotListener({ [weak self](snapshot, error) in
            if let error = error {

                DispatchQueue.main.async {
                    self?.showAlert(title: "Firestore Error (Cannot Retrieve Data)", message: "\(error.localizedDescription)")
                }
            } else if let snapshot = snapshot {
                guard let data = snapshot.data() else {return}
                let artist = Artist(data)
                self?.tags = artist.preferences ?? ["no tags"]
            }
        })
    }


    private func setUpCVs() {
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        featuredArtistCV.delegate = featuredCVDelegate
        featuredArtistCV.dataSource = self
    }
    
    private func setUpTV() {
        artistTableView.delegate = self
        artistTableView.dataSource = self
    }
    
    func fetchArtists(){
        db.getArtists { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                
            case.success(let artists1):
                self?.artists = artists1
                print(self?.artists.count ?? 0)
            }
        }
    }
    
    func getCurrentUserPref(){
        guard let user = Auth.auth().currentUser else {return}
        
        db.fetchArtist(userID: user.uid) { [weak self](result) in
            switch result {
            case.failure(let error):
                print(error.localizedDescription)
                
            case.success(let currentUser1):
                self?.currentUser = currentUser1
                self?.tags = currentUser1.preferences ?? ["no tags","no tags"]
                
            }
        }
    }
    
}


extension ExploreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell", for: indexPath) as? ExploreArtistCell else {
            fatalError("could not conform to ExploreArtistCell")
        }
        
        let artist = artists[indexPath.row]
        cell.configureCell(artist: artist)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "MainView", bundle:  nil)
        guard let profVC = storyBoard.instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController else {
            fatalError("could not load ProfileViewController")
        }
        let artist = artists[indexPath.row]
        profVC.expArtist = artist
        
        profVC.state = .explore
        navigationController?.pushViewController(profVC, animated: true)
    }
    
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == tagsCollectionView {
        
        return currentUser?.preferences?.count ?? 2
    }
        
        if collectionView == featuredArtistCV {
            return featuredArtistPlaceHolderImages.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == tagsCollectionView {
        
        guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as? TagCollectionViewCell else {
            fatalError("could not downcast to TagCollectionViewCell")
        }
      
        let tag = currentUser?.preferences?[indexPath.row] ?? "no tag"
             tagCell.configureCell(tag)
        

        return tagCell
    }
        if collectionView == featuredArtistCV {
            guard let featureCell = collectionView.dequeueReusableCell(withReuseIdentifier: "featuredArtist", for: indexPath) as? FeaturedArtistCell else {
                fatalError("could not downcast to FeaturedArtistCell")
            }
            let placeHolder = featuredArtistPlaceHolderImages[indexPath.row]
            
            featureCell.configureCell(placeHolderImage: placeHolder)
            featureCell.imageView.layer.cornerRadius = 30
            
            return featureCell
        }
        
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.20
        let itemHeight: CGFloat = maxSize.height * 0.30
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension ExploreViewController: UpdateUsertPref {
    func didUpdatePreferences(_ tags: [String], _ exploreVC: ExploreOptionsController) {
        getCurrentUserPref()
        tagsCollectionView.reloadData()
        artistTableView.reloadData()
        
        db.getArtists { (result) in
            switch result {
            case .failure(let error):
                print(error)
                
            case .success(let filteredArtist):
                for pref in self.currentUser?.preferences ?? ["none"] {
                    
                self.artists = filteredArtist.filter{ $0.tags.contains(pref) }
                }
            }
        }

    }
}
    
    

