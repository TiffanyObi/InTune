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
    
    override func loadView() {
        view = likedArtistView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

       setUpCollectionView()
        likedArtistView.likedArtistCollectionView.register(UINib(nibName: "ArtistCell", bundle: nil), forCellWithReuseIdentifier: "artistCell")

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
        artistCell.layer.cornerRadius = 10
        artistCell.layer.borderColor = #colorLiteral(red: 0.3867273331, green: 0.8825651407, blue: 0.8684034944, alpha: 1)
        artistCell.layer.borderWidth = 4
        artistCell.configureFavArtistCell(favArtist: favArtist)
        
        return artistCell

    }
    
}


extension LikedArtistsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.9
        let itemHeight: CGFloat = maxSize.height * 0.18
        return CGSize(width: itemWidth, height: itemHeight)
    }

}
