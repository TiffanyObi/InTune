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
    
    var instruments = [String]()
    var genres = [String]()
    
//    var selectedInstruments = Set<String>()
//    var selectedGenres = Set<String>()
    
    var selectedTags = Set<String>()

    
    let db = DatabaseService()
    
//     private var tagsObserver: NSKeyValueObservation?
    
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
        
        instrumentsCollectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tagCell")
        
        genresCollectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tagCell")
    }
    
    private func loadCollectionViews(){
        instruments = Tags.instrumentList
        genres = Tags.genreList
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
    
//    private func configureTagsObservation(){
//        tagsObserver = self.observe(\.selectedTags, options: [.old,.new], changeHandler: { [weak self](tags, change) in
//            guard let tags = change.newValue else { return }
//
//        })
//    }
    
    
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
                if collectionView == instrumentsCollectionView {
                
            guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as? TagCollectionViewCell else {
                fatalError("could not downcast to TagCollectionViewCell")
            }
                let instrument = instruments[indexPath.row]
                    tagCell.tagTitle.backgroundColor = .purple
                tagCell.tagTitle.text = instrument
                tagCell.tagTitle.textColor = .white
                return tagCell
                
        }
            if collectionView == genresCollectionView{
                guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as? TagCollectionViewCell else { fatalError("could not downcast to TagCollectionViewCell")
                }
                
                let genre = genres[indexPath.row]
                tagCell.tagTitle.backgroundColor = .systemTeal
                tagCell.tagTitle.textColor = .white
                tagCell.tagTitle.text = genre
                return tagCell
            }
            
            return TagCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.25
        let itemHeight: CGFloat = maxSize.height * 0.10
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == instrumentsCollectionView {
            
            let selectedInstrument = instruments[indexPath.row]
          
            selectedTags.insert(selectedInstrument)
            print(selectedTags)
            
        }
        
        if collectionView == genresCollectionView {
            
            let selectedGenre = genres[indexPath.row]
            selectedTags.insert(selectedGenre)
            
            print(selectedTags)
        }
    }

    
}
