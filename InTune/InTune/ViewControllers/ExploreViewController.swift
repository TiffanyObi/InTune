//
//  ExploreViewController.swift
//  InTune
//
//  Created by Tiffany Obi on 5/26/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {

    @IBOutlet private var tagsCollectionView: UICollectionView!
    @IBOutlet private var viewSegmentedControl: UISegmentedControl!
    @IBOutlet private var artistTableView: UITableView!
    @IBOutlet private var featuredArtistCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        tagsCollectionView.register(GenreTag.self, forCellWithReuseIdentifier: "genreTag")
        featuredArtistCV.delegate = self
        featuredArtistCV.dataSource = self
    }


}

extension ExploreViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell", for: indexPath) as? ExploreArtistCell else {
            fatalError("could not conform to ExploreArtistCell")
        }
        
        return cell
    }
    
    
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.40
        let itemHeight: CGFloat = maxSize.height * 0.20
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreTag", for: indexPath) as? GenreTag else {
            fatalError("could not conform to GenreTag")
        }
        
        return cell
    }
    
    
}
