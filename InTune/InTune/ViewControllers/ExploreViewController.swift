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
    @IBOutlet private var artistTableView: UITableView!
    @IBOutlet private var featuredArtistCV: UICollectionView!
    
    let tabsCVDelegate = TagsCVDelegate()
    let featuredCVDelegate = FeaturedArtistCVDelegate()
    
    let db = DatabaseService()
    
    var artists = [Artist](){
        didSet{
            DispatchQueue.main.async {
                self.artistTableView.reloadData()
            }
        }
    }
    let height: CGFloat = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArtists()
        tagsCollectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tagCell")
        artistTableView.register(ExploreArtistCell.self, forCellReuseIdentifier: "exploreCell")
        featuredArtistCV.register(UINib(nibName: "FeaturedArtist", bundle: nil), forCellWithReuseIdentifier: "featuredArtist")
        setUpCVs()
        setUpTV()
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
    
    func fetchArtists(){
        db.getArtists { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                
            case.success(let artists1):
                self?.artists = artists1
                
                print(self?.artists.count ?? 0)
            }
        }
    }

}


extension ExploreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell", for: indexPath) as? ExploreArtistCell else {
            fatalError("could not conform to ExploreArtistCell")
        }
        
        let artist = artists[indexPath.row]
        cell.configureCell(artist: artist)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "MainView", bundle:  nil)
        guard let profVC = storyBoard.instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController else {
            fatalError("could not load ProfileViewController")
        }
        let artist = artists[indexPath.row]
        profVC.expArtist = artist
        profVC.state = .explore
        navigationController?.pushViewController(profVC, animated: true)
    }
    
}
