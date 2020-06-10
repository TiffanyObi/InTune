//
//  TagsSelectionView.swift
//  InTune
//
//  Created by Tiffany Obi on 6/9/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class TagsSelectionView: UIView {

    private lazy var instrumentsLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Which Instruments Do You Play?"
        label.font = UIFont(name: "Didot", size: 20.0)
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    public lazy var instrumentsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemGroupedBackground
        return cv
    }()
    private lazy var genresLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Which Genres Do You Favor?"
        label.font = UIFont(name: "Didot", size: 20.0)
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    public lazy var genresCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemGroupedBackground
        return cv
    }()
    
    public lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("D O N E", for: .normal)
        button.backgroundColor = .purple
        button.tintColor = .white
        return button
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
            setUpInstrumentsLabel()
            setUpInstrumentCollectionView()
            setUpGenresLabel()
            setUpGenreCollectionView()
        }
    func setUpInstrumentsLabel(){
        addSubview(instrumentsLabel)
        instrumentsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            instrumentsLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 25),
            instrumentsLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            instrumentsLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
            
        ])
    }
    
    func setUpInstrumentCollectionView(){
        addSubview(instrumentsCollectionView)
        instrumentsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            instrumentsCollectionView.topAnchor.constraint(equalTo: instrumentsLabel.bottomAnchor, constant: 20),
            instrumentsCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            instrumentsCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            instrumentsCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25)
        
        ])
    }
    
    func setUpGenresLabel(){
        addSubview(genresLabel)
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            genresLabel.topAnchor.constraint(equalTo: instrumentsCollectionView.bottomAnchor, constant: 40),
            genresLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            genresLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
            
        ])
    }
    
    
    
    func setUpGenreCollectionView(){
        addSubview(genresCollectionView)
        genresCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genresCollectionView.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 20),
            genresCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            genresCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            genresCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25)
        
        ])
    }
    
    
}
