//
//  LikedArtistView.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class LikedArtistView: UIView {
    
    private lazy var likedArtistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Didot", size: 30)
        label.text = "Liked Artists"
        return label
    }()
    
    public lazy var likedArtistCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame:UIScreen.main.bounds)
        commomInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        commomInit()
    }
    
    private func commomInit() {
        setLikedArtistLabel()
        setUpLikedArtistCollectionViewConstraints()
        
    }
    
    
    private func setLikedArtistLabel(){
        addSubview(likedArtistLabel)
        likedArtistLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likedArtistLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            likedArtistLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            likedArtistLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
            
        ])
    }
    private func setUpLikedArtistCollectionViewConstraints(){
        addSubview(likedArtistCollectionView)
        likedArtistCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likedArtistCollectionView.topAnchor.constraint(equalTo: likedArtistLabel.bottomAnchor, constant: 16),
            likedArtistCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            likedArtistCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            likedArtistCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7)
        ])
    }
    
    
}

