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
       

    }
    
    private func setUpCollectionView(){
        
        likedArtistView.likedArtistCollectionView.dataSource = self
        likedArtistView.likedArtistCollectionView.delegate = self
        likedArtistView.contactsCollectionView.dataSource = self
        likedArtistView.contactsCollectionView.delegate = self
        

    }

  

}

extension LikedArtistsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   let cell = UICollectionViewCell()
        return cell
    }
    
    
}

extension LikedArtistsViewController: UICollectionViewDelegateFlowLayout {
    
}
