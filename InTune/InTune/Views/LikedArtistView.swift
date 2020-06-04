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
    private lazy var contactsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Didot", size: 20)
        label.text = "Contacts"
        return label
    }()
    
    public lazy var likedArtistCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemGray2
        return cv
    }()
    
    public lazy var contactsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemGray2
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
        setUpContactsLabel()
        setUpContactsCollectionViewContraints()
        
    }
    
    
    private func setLikedArtistLabel(){
        addSubview(likedArtistLabel)
        likedArtistLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likedArtistLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            likedArtistLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)
            
        ])
    }
    private func setUpLikedArtistCollectionViewConstraints(){
        addSubview(likedArtistCollectionView)
        likedArtistCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likedArtistCollectionView.topAnchor.constraint(equalTo: likedArtistLabel.bottomAnchor, constant: 8),
            likedArtistCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            likedArtistCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            likedArtistCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45)
            
        ])
    }
    
    private func setUpContactsLabel(){
        addSubview(contactsLabel)
        contactsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contactsLabel.topAnchor.constraint(equalTo: likedArtistCollectionView.bottomAnchor, constant: 20),
            contactsLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            contactsLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)
            
        ])
    }
    
    private func setUpContactsCollectionViewContraints(){
        addSubview(contactsCollectionView)
        contactsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contactsCollectionView.topAnchor.constraint(equalTo: contactsLabel.bottomAnchor, constant: 8),
            contactsCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            contactsCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            contactsCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.20)
            
        ])
    }
    
    
}

