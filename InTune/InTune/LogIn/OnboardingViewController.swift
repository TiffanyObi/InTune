//
//  OnboardingViewController.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

struct TagCollectionViewCellModel {
    var name: String
    var isSelected: Bool
}

class OnboardingViewController: UIViewController {
    
    let userExperienece = UserExperienceView()
    let displayNameAndLocation = DisplayNameAndLocationView()
    let tagsSelectionView = TagsSelectionView()
    
    let database = DatabaseService()
    
    let states = StatesForPickerView.states
    var displayName = ""
    var userLocation = ""
    
    var instruments = [TagCollectionViewCellModel]()
    var genres = [TagCollectionViewCellModel]()
    
    var selectedInstruments = Set<String>()
    var selectedGenres = Set<String>()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(resignTextfeilds))
        return gesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = userExperienece
        view.backgroundColor = .systemGroupedBackground
        setUpButtonOnExperienceView()
        setUpTextFeildFroDisplayNameView()
        setUpPickerViewForLocationView()
        setUpNextButton()
        setUpCollectionViews()
        loadCollectionViews()
        setUpDoneButton()
        view.addGestureRecognizer(tapGesture)
        userLocation = states.first!
    }
    
    
    
    @objc private func resignTextfeilds(){
        displayNameAndLocation.displayNameTextfield.resignFirstResponder()
    }
    
    func setUpButtonOnExperienceView(){
        userExperienece.artistButton.addTarget(self, action: #selector(artistExperience), for: .touchUpInside)
        
        userExperienece.enthusiastButton.addTarget(self, action: #selector(enthusiastExperiance), for: .touchUpInside)
    }
    
    func setUpTextFeildFroDisplayNameView(){
        displayNameAndLocation.displayNameTextfield.delegate = self
    }
    
    func setUpPickerViewForLocationView(){
        displayNameAndLocation.locationPickerView.dataSource = self
        displayNameAndLocation.locationPickerView.delegate = self
    }
    
    func setUpNextButton(){
        displayNameAndLocation.nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
    
    func setUpCollectionViews(){
        tagsSelectionView.instrumentsCollectionView.dataSource = self
        tagsSelectionView.instrumentsCollectionView.delegate = self
        tagsSelectionView.genresCollectionView.dataSource = self
        tagsSelectionView.genresCollectionView.delegate = self
        
        tagsSelectionView.instrumentsCollectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tagCell")
        
        tagsSelectionView.genresCollectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tagCell")
    }
    private func loadCollectionViews(){
        instruments = Tags.instrumentList.map {TagCollectionViewCellModel(name: $0, isSelected: false)}
        genres = Tags.genreList.map {TagCollectionViewCellModel(name: $0, isSelected: false)}
    }
    func setUpDoneButton(){
        tagsSelectionView.doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
    }
    
    @objc func artistExperience() {
        database.updateUserExperience(isAnArtist: true) { [weak self](result) in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error", message: "\(error.localizedDescription)")
            case .success:
                self?.navigateToDisplayNameAndCityView()
            }
        }
    }
    
    @objc func enthusiastExperiance() {
        database.updateUserExperience(isAnArtist: false) { [weak self](result) in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error", message: "\(error.localizedDescription)")
            case .success:
                
                self?.navigateToDisplayNameAndCityView()
            }
            
        }
    }
        
        private func navigateToDisplayNameAndCityView(){
            view = displayNameAndLocation
            view.backgroundColor = .systemBackground
        }
        @objc private func nextButtonPressed(){
            
            guard !displayName.isEmpty else {
                showAlert(title: "Missing Fields", message: " Please create a unique user name")
                return
            }
            
            guard !userLocation.isEmpty else {
                showAlert(title: "Missing Fields", message: "Please tell us where you're located")
                return
            }
            
            database.updateUserDisplayNameAndLocation(userName: displayName, location: userLocation) { [weak self](result) in
                switch result {
                case.failure(let error):
                    self?.showAlert(title: "Error", message: "\(error.localizedDescription)")
                case.success:
                    print(true)
                    self?.navigateToTagsSelectionView()
                }
            }
        }
        private func navigateToTagsSelectionView(){
            view = tagsSelectionView
            view.backgroundColor = .systemGroupedBackground
        }
        
        @objc private func doneButtonPressed(){
            
//            guard !selectedInstruments.isEmpty,!selectedGenres.isEmpty else {
//                showAlert(title: "Missing Selections", message: "What instruments or genres are you interested in ?")
//                return
//                
//            }
            
            let instruments1 = Array(selectedInstruments)
            let genres1 = Array(selectedGenres)
            
            database.updateUserTags(instruments: instruments1, genres: genres1) { [weak self](result) in
                switch result {
                case.failure(let error):
                    self?.showAlert(title: "Error", message: "\(error.localizedDescription)")
                case.success:
                    self?.navigateToProfileView()
                }
            }
        }
        
        func navigateToProfileView(){
            UIViewController.showViewController(storyboardName: "MainView", viewControllerID: "MainViewTabBarController")
        }
    }
    
    extension OnboardingViewController: UITextFieldDelegate {
        func textFieldDidChangeSelection(_ textField: UITextField) {
            guard !(textField.text?.isEmpty ?? true) else {
                
                return}
            displayName = textField.text ?? "no display name"
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            
            return true
        }
    }
    
    extension OnboardingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            
            return states.count
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            
            return states[row]
        }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            userLocation = states[row]
        }
        
    }
    
    extension OnboardingViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            if collectionView == tagsSelectionView.instrumentsCollectionView {
                return instruments.count
            }
            
            if collectionView == tagsSelectionView.genresCollectionView{
                return genres.count
            }
            
            return 2
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as? TagCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if collectionView == tagsSelectionView.instrumentsCollectionView {
                let instrument = instruments[indexPath.row]
                tagCell.tagTitle.backgroundColor = .black
                tagCell.layer.borderWidth = 4
                tagCell.layer.borderColor = #colorLiteral(red: 0.3867273331, green: 0.8825651407, blue: 0.8684034944, alpha: 1)
                tagCell.isButtonPressed = { [weak self] in
                    self?.instruments[indexPath.row].isSelected = true
                    self?.selectedInstruments.insert(instrument.name)
                }
                tagCell.tagTitle.textColor = .white
                tagCell.configureWithModel(instrument)
                
                return tagCell
                
            }
            if collectionView == tagsSelectionView.genresCollectionView{
                let genre = genres[indexPath.row]
                tagCell.tagTitle.backgroundColor = .black
                tagCell.layer.borderWidth = 4
                tagCell.layer.borderColor = #colorLiteral(red: 0.3867273331, green: 0.8825651407, blue: 0.8684034944, alpha: 1)
                
                tagCell.isButtonPressed = { [weak self] in
                    self?.genres[indexPath.row].isSelected = true
                    self?.selectedGenres.insert(genre.name)
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
    
    extension OnboardingViewController: TagsCVDelegate {
        func updateUserPreferences(_ cell: TagCollectionViewCell, instrument: String, genre: String) {
            if !instrument.isEmpty {
                selectedInstruments.insert(instrument)
            }
            
            if !genre.isEmpty {
                selectedGenres.insert(genre)
            }
        }
        
        
        
}

