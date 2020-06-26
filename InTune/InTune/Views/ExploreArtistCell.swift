//
//  ExploreArtistCell.swift
//  InTune
//
//  Created by Maitree Bain on 6/5/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class ExploreArtistCell: UITableViewCell {
    
    public lazy var artistImage: UIImageView = {
        let image = UIImageView()
        image.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        image.image = UIImage(systemName: "person.crop.square")
        return image
    }()
    
    public lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont(name: "Thonburi", size: 22.0)
        return label
    }()
    
    public lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "location"
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setUpArtistImageConstraints()
        setUpNameConstraints()
        setUpLocationLabelConstraints()
    }
    
    private func setUpArtistImageConstraints() {
        addSubview(artistImage)
        
        artistImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            artistImage.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            artistImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            artistImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            artistImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.28)
        ])
    }
    
    private func setUpNameConstraints() {
        addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: artistImage.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20)
        ])
    }
    
    private func setUpLocationLabelConstraints() {
        addSubview(locationLabel)
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            locationLabel.leadingAnchor.constraint(equalTo: artistImage.trailingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    public func configureCell(artist:Artist){
        nameLabel.text = artist.name
        locationLabel.text = artist.city
        
        if let urlString = artist.photoURL, let url = URL(string: urlString) {
            
            artistImage.kf.setImage(with: url)
        } else {
            artistImage.image = UIImage(systemName: "person.crop.square")
        }
    }
    
}
