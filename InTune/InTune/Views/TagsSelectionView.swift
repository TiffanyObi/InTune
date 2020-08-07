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
        label.text = "Which instruments do you play?"
        label.font = UIFont(name: "Thonburi", size: 26.0)
        label.backgroundColor = .systemGroupedBackground
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    public lazy var instrumentsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemGroupedBackground
        return cv
    }()
    private lazy var genresLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Which genres do you favor?"
        label.font = UIFont(name: "Thonburi", size: 26.0)
        label.backgroundColor = .systemGroupedBackground
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    public lazy var genresCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemGroupedBackground
        return cv
    }()
    
    public lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
        button.titleLabel?.textColor = .white
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
            setUpDoneButton()
        }
    func setUpInstrumentsLabel(){
        addSubview(instrumentsLabel)
        instrumentsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            instrumentsLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            instrumentsLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            instrumentsLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
            
        ])
    }
    
    func setUpInstrumentCollectionView(){
        addSubview(instrumentsCollectionView)
        instrumentsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            instrumentsCollectionView.topAnchor.constraint(equalTo: instrumentsLabel.bottomAnchor, constant: 16),
            instrumentsCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            instrumentsCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            instrumentsCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.30)
        
        ])
    }
    
    func setUpGenresLabel(){
        addSubview(genresLabel)
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            genresLabel.topAnchor.constraint(equalTo: instrumentsCollectionView.bottomAnchor, constant: 32),
            genresLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            genresLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
            
        ])
    }
    
    
    
    func setUpGenreCollectionView(){
        addSubview(genresCollectionView)
        genresCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genresCollectionView.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 16),
            genresCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            genresCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            genresCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.20)
        
        ])
    }
    
    func setUpDoneButton(){
        addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: genresCollectionView.bottomAnchor, constant: 24),
            doneButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 100),
            doneButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -100),
            doneButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.10)
        
        
        ])
    }
}
