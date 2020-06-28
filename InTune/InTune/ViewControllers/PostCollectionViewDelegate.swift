//
//  PostCollectionViewDelegate.swift
//  InTune
//
//  Created by Maitree Bain on 6/8/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

enum ViewControllerStates{
    case explore(tags: Int)
    case profile(tags: Int)
    case gigs(tags: Int)
}

class PostCollectionViewDelegate: NSObject,UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.40
        let itemHeight: CGFloat = maxSize.height * 0.40
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? PostCell else {
            fatalError("could not conform to postCell")
        }
        
        return cell
    }
    
    
    
}

class FeaturedArtistCVDelegate: NSObject,UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
           
               cell.colorShadow(for: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.28
        let itemHeight: CGFloat = maxSize.height * 0.28
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featuredArtist", for: indexPath) as? FeaturedArtistCell else {
            fatalError("could not conform to FeaturedArtistCell")
        }
        cell.clipsToBounds = true
        return cell
    }
    
    
}
