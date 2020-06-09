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
    
    let tabsCVDelegate = TagsCVDelegate()
    let featuredCVDelegate = FeaturedArtistCVDelegate()
    
    let height: CGFloat = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagsCollectionView.delegate = tabsCVDelegate
        tagsCollectionView.dataSource = tabsCVDelegate
        artistTableView.delegate = self
        artistTableView.dataSource = self
        artistTableView.register(ExploreArtistCell.self, forCellReuseIdentifier: "exploreCell")
        featuredArtistCV.register(UINib(nibName: "FeaturedArtist", bundle: nil), forCellWithReuseIdentifier: "featuredArtist")
        featuredArtistCV.delegate = featuredCVDelegate
        featuredArtistCV.dataSource = featuredCVDelegate
    }


}


extension ExploreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height
    }
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
