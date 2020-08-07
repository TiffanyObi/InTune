//
//  LikedArtistView.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class LikedArtistView: UIView {
    
    public lazy var likedArtistSearchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search an artist by name"
        search.layer.cornerRadius = 20
        search.layer.masksToBounds = true
        search.searchTextField.backgroundColor = .systemGroupedBackground
        search.searchTextField.textColor = .label
        return search
    }()
    
    public lazy var likedArtistCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemGray6
        cv.layer.cornerRadius = 20
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
        setUpSearchBarConstraints()
        setUpLikedArtistCollectionViewConstraints()
    }
    
    private func setUpSearchBarConstraints() {
        addSubview(likedArtistSearchBar)
        
        likedArtistSearchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likedArtistSearchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            likedArtistSearchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            likedArtistSearchBar.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setUpLikedArtistCollectionViewConstraints(){
        addSubview(likedArtistCollectionView)
        likedArtistCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likedArtistCollectionView.topAnchor.constraint(equalTo: likedArtistSearchBar.bottomAnchor, constant: 8),
            likedArtistCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            likedArtistCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            likedArtistCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7)
        ])
    }
    
    
}

