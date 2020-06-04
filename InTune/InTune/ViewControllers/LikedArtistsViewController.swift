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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Chat", style: .plain, target: self, action: #selector(showMessages))
    }
    
    private func setUpCollectionView(){
        
        likedArtistView.likedArtistCollectionView.dataSource = self
        likedArtistView.likedArtistCollectionView.delegate = self
        likedArtistView.contactsCollectionView.dataSource = self
        likedArtistView.contactsCollectionView.delegate = self
        
        
    }
    
    @objc private func showMessages() {
        let storyboard = UIStoryboard(name: "MessageView", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "ChatsViewController") as ChatsViewController
        navigationController?.show(viewController, sender: self)
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
