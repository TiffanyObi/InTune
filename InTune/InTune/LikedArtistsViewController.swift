//
//  LikedArtistsViewController.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LikedArtistsViewController: UIViewController {
    
    private var likedArtistView = LikedArtistView()
    var listener:ListenerRegistration?
    
    var favs = [FavoritedArtist](){
        didSet {
            DispatchQueue.main.async {
                self.likedArtistView.likedArtistCollectionView.reloadData()
            }
            setUpEmptyView()
        }
    }
    
    let db = DatabaseService()
    
    var currentArtist: Artist?
    
    var artists = [Artist]() {
        didSet {
            self.likedArtistView.likedArtistCollectionView.reloadData()
        }
    }
    
    var searchQuery = "" {
        didSet {
            favs = favs.filter { $0.favArtistName.lowercased().contains(searchQuery.lowercased())}
        }
    }
    
    override func loadView() {
        view = likedArtistView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        getArtist()
        loadFavArtists()
        likedArtistView.likedArtistSearchBar.delegate = self
        setUpCollectionView()
        likedArtistView.likedArtistCollectionView.register(UINib(nibName: "ArtistCell", bundle: nil), forCellWithReuseIdentifier: "artistCell")
        navigationItem.title = "Liked Artists"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipses.bubble.fill"), style: .plain, target: self, action: #selector(showMessages))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard let user = Auth.auth().currentUser else { return }
        listener = Firestore.firestore().collection(DatabaseService.artistsCollection).document(user.uid).collection(DatabaseService.favCollection).addSnapshotListener({ [weak self](snapshot, error) in
            if let error = error {
                
                DispatchQueue.main.async {
                    self?.showAlert(title: "Firestore Error (Cannot Retrieve Data)", message: "\(error.localizedDescription)")
                }
            } else if let snapshot = snapshot {
                let favs = snapshot.documents.map { FavoritedArtist($0.data()) }
                self?.addArtists(favs: favs)
                self?.favs = favs
                
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        listener?.remove()
    }
    
    
    private func setUpCollectionView(){
        
        likedArtistView.likedArtistCollectionView.dataSource = self
        likedArtistView.likedArtistCollectionView.delegate = self
    }
    
    private func getArtist() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        db.fetchArtist(userID: user.uid) { [weak self] (result) in
            
            switch result {
            case .failure(let error):
                print("\(error.localizedDescription)")
            case .success(let artist):
                self?.currentArtist = artist
            }
        }
    }
    
    private func loadFavArtists() {
        guard let artist = currentArtist else { return }
        db.fetchFavArtists(artist: artist) { (result) in
            
            switch result {
            case .failure(let error):
                print("\(error.localizedDescription)")
            case .success(let artists):
                self.favs = artists
            }
        }
    }
    
    
    private func addArtists(favs: [FavoritedArtist]) {
        for fav in favs {
            let artist = Artist(name: fav.favArtistName, email: "", artistId: fav.favArtistID, tags: fav.favArtistTag, city: fav.favArtistLocation, isAnArtist: true, createdDate: Timestamp(), photoURL: fav.favPhotoURL, bioText: "", preferences: [""], isReported: false)
            artists.insert(artist, at: artists.endIndex)
        }
    }
    
    
    private func setUpEmptyView() {
        if favs.count == 0 {
            let emptyView = EmptyView(message: "You have no liked artists")
            likedArtistView.likedArtistCollectionView.backgroundView = emptyView
        } else {
            likedArtistView.likedArtistCollectionView.backgroundView = nil
        }
    }
    
    @objc private func showMessages() {
        let storyboard = UIStoryboard(name: "MessageView", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "ChatsViewController") as ChatsViewController
        navigationController?.show(viewController, sender: self)
    }
    
}

extension LikedArtistsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let artistCell = collectionView.dequeueReusableCell(withReuseIdentifier:"artistCell", for: indexPath) as? ArtistCell else {
            fatalError("Could not downcast to ArtistCell")
        }
        let favArtist = favs[indexPath.row]
        artistCell.configureFavArtistCell(favArtist: favArtist)
        
        return artistCell
    }
    
}

extension LikedArtistsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chatVC = ChatViewController()
        let fav = favs[indexPath.row]
        let artist = artists[indexPath.row]
        print(fav)
        print(artist)
        if artist.artistId == fav.favArtistID {
            chatVC.artist = artist
            print(artist)
        }
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.colorShadow(for: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.9
        let itemHeight: CGFloat = maxSize.height * 0.18
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}

extension LikedArtistsViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else { return }
        
        if searchText.isEmpty {
            loadFavArtists()
        }
        
        searchQuery = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        loadFavArtists()
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
}
