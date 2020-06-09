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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagsCollectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tagCell")
        artistTableView.register(ExploreArtistCell.self, forCellReuseIdentifier: "exploreCell")
        featuredArtistCV.register(UINib(nibName: "FeaturedArtist", bundle: nil), forCellWithReuseIdentifier: "featuredArtist")
        setUpCVs()
        setUpTV()
        setUpSegmentedControl()
    }
    
    private func setUpCVs() {
        tagsCollectionView.delegate = tabsCVDelegate
        tagsCollectionView.dataSource = tabsCVDelegate
        featuredArtistCV.delegate = featuredCVDelegate
        featuredArtistCV.dataSource = featuredCVDelegate
    }

    private func setUpTV() {
        artistTableView.delegate = self
        artistTableView.dataSource = self
    }
    
    private func setUpSegmentedControl() {
        viewSegmentedControl.selectedSegmentTintColor = #colorLiteral(red: 0.3867273331, green: 0.8825651407, blue: 0.8684034944, alpha: 1)
    }

}


extension ExploreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
