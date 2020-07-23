//
//  ExploreOptionsController.swift
//  InTune
//
//  Created by Tiffany Obi on 6/11/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

protocol UpdateUsertPref:AnyObject {
    func didUpdatePreferences(_ tags: [String], _ exploreVC:ExploreOptionsController)
}

class ExploreOptionsController: UIViewController {
    
    @IBOutlet weak var instrumentsCollectionView: UICollectionView!
    
    @IBOutlet weak var genresCollectionView: UICollectionView!
    
    var instruments = [TagCollectionViewCellModel]()
    var genres = [TagCollectionViewCellModel]()
    
    var selectedTags = Set<String>()
    
    var instrumentIndex: Int?
    var genreIndex: Int?
    let db = DatabaseService()
    
    weak var prefDelegate: UpdateUsertPref?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionViews()
        loadCollectionViews()
    }
    
    func setUpCollectionViews(){
        instrumentsCollectionView.dataSource = self
        instrumentsCollectionView.delegate = self
        genresCollectionView.dataSource = self
        genresCollectionView.delegate = self
        
        instrumentsCollectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TagCollectionViewCell.cellIdentifier)
        
        genresCollectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TagCollectionViewCell.cellIdentifier)
    }
    
    private func loadCollectionViews(){
        instruments = Tags.instrumentList.map {TagCollectionViewCellModel(name: $0, isSelected: false)}
        genres = Tags.genreList.map {TagCollectionViewCellModel(name: $0, isSelected: false)}
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        guard !selectedTags.isEmpty else {return}
        
        db.updateUserPreferences(Array(selectedTags)) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                
            case.success:
                print(true)
                
                self?.prefDelegate?.didUpdatePreferences(Array(self?.selectedTags ?? [""]), self ?? ExploreOptionsController())
                
                self?.dismiss(animated: true)
                
            }
        }
        
    }
    
}

extension ExploreOptionsController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == instrumentsCollectionView {
            return instruments.count
        }
        
        if collectionView == genresCollectionView{
            return genres.count
        }
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as? TagCollectionViewCell else {
            return UICollectionViewCell()
        }

        if collectionView == instrumentsCollectionView {
            let instrument = instruments[indexPath.row]
            tagCell.tagTitle.backgroundColor = .black
            tagCell.layer.borderWidth = 4
            tagCell.layer.borderColor = #colorLiteral(red: 0.3867273331, green: 0.8825651407, blue: 0.8684034944, alpha: 1)
            
            tagCell.isButtonPressed = { [weak self] in
                self?.instruments[indexPath.row].isSelected = true
                self?.selectedTags.insert(instrument.name)
            }
            tagCell.tagTitle.textColor = .white
            
            tagCell.configureWithModel(instrument)
            
            
            
        }
        if collectionView == genresCollectionView{
            let genre = genres[indexPath.row]
            tagCell.tagTitle.backgroundColor = .black
            tagCell.layer.borderWidth = 4
            tagCell.layer.borderColor = #colorLiteral(red: 0.3429883122, green: 0.02074946091, blue: 0.7374325991, alpha: 1)
            tagCell.tagTitle.textColor = .white
            
            tagCell.isButtonPressed = { [weak self] in
                self?.genres[indexPath.row].isSelected = true
                self?.selectedTags.insert(genre.name)
            }
             tagCell.tagTitle.textColor = .white
             
             tagCell.configureWithModel(genre)
        }
        
        return tagCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.25
        let itemHeight: CGFloat = maxSize.height * 0.10
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension ExploreOptionsController {
    func updateUserPreferences(instrument: String, genre: String) {
        if !instrument.isEmpty {
            selectedTags.insert(instrument)
        }
        if !genre.isEmpty {
            selectedTags.insert(genre)
        }
        
        print(selectedTags)
    }
    
}
