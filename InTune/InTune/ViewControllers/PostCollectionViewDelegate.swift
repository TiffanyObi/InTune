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
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? PostCell else {
            fatalError("could not conform to postCell")
        }
        
        return cell
    }
    
    
    
}

class TagsCVDelegate: NSObject,UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.20
        let itemHeight: CGFloat = maxSize.height * 0.30
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as? TagCollectionViewCell else {
            fatalError("could not conform to TagCell")
        }
        
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    
}

class FeaturedArtistCVDelegate: NSObject,UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   //     let itemSpacing: CGFloat = 1
    //    let maxSize: CGSize = UIScreen.main.bounds.size
     //   let numberOfItems: CGFloat = 1
     //   let totalSpace: CGFloat = numberOfItems * itemSpacing
       // let maxS: CGFloat = maxSize.height * 0.1
      //  let itemWidth: CGFloat = (maxS - totalSpace) / numberOfItems
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.60
        let itemHeight: CGFloat = maxSize.height * 0.60
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featuredArtist", for: indexPath) as? FeaturedArtistCell else {
            fatalError("could not conform to FeaturedArtistCell")
        }
        
        return cell
    }
    
    
}
