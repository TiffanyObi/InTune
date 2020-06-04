//
//  LikedArtistsViewController.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class LikedArtistsViewController: UIViewController {
    
    private var likedArtistView = LikedArtistView()

    override func loadView() {
        view = likedArtistView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
       setUpCollectionView()
        likedArtistView.likedArtistCollectionView.register(UINib(nibName: "ArtistCell", bundle: nil), forCellWithReuseIdentifier: "artistCell")
    }
    
    private func setUpCollectionView(){
        
        likedArtistView.likedArtistCollectionView.dataSource = self
        likedArtistView.likedArtistCollectionView.delegate = self
//        likedArtistView.contactsCollectionView.dataSource = self
//        likedArtistView.contactsCollectionView.delegate = self
        
        
//        likedArtistView.contactsCollectionView.register(ArtistCell.self, forCellWithReuseIdentifier: "artistCell")

    }

  

}

extension LikedArtistsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let artistCell = collectionView.dequeueReusableCell(withReuseIdentifier:"artistCell", for: indexPath) as? ArtistCell else {
            fatalError("Could not downcast to ArtistCell")
        }
        
        return artistCell
    }
    
    
}

extension LikedArtistsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize:CGSize = UIScreen.main.bounds.size
        let itemWidth:CGFloat = maxSize.width * 0.4
        return CGSize(width: itemWidth, height: collectionView.bounds.size.height * 0.3)
    }
    
}
