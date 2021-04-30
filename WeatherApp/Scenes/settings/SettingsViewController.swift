//
//  SettingsViewController.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 29. 4. 2021..
//

import UIKit

protocol SettingsDelegate: class{
    func didCloseSettings()
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var metricsButton: UIButton!
    @IBOutlet weak var imperialButton: UIButton!
    @IBOutlet weak var humidityButton: CheckCircle!
    @IBOutlet weak var windButton: CheckCircle!
    @IBOutlet weak var pressureButton: CheckCircle!
    @IBOutlet weak var doneButton: UIButton!
    
    private var locations: [Location] = [] {
        didSet{
            collectionView.reloadData()
        }
    }
    
    private var conditions: [Condition] = []
    private var defaultsManager = DefaultsManager()
    
    weak var delegate: SettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScreen()
        setCollection()
    }
    
    
    // MARK: - Initial setup
    private func setScreen(){
        // LOCATIONS
        locations = defaultsManager.choosenLocations ?? []
        
        // UNITS
        let units = defaultsManager.units
        
        if units == "metric" {
            metricsButton.setImage(UIImage(named : "square_check"), for: .normal)
            metricsButton.isSelected = true
        } else {
            imperialButton.isSelected = true
            imperialButton.setImage(UIImage(named : "square_check"), for: .normal)
        }
        
        // CONDITIONS
        conditions = defaultsManager.choosenConditions ?? []
        
        for condition in conditions {
            switch condition.type{
            
            case .humidity:
                humidityButton.isChecked = condition.selected
            case .wind:
                windButton.isChecked = condition.selected
            case .pressure:
                pressureButton.isChecked = condition.selected
            }
        }
        
        doneButton.layer.cornerRadius = 24
    }
    
    private func setCollection(){
        let locationCell = UINib(nibName: "SettingsLocationViewCell", bundle: nil)
        collectionView.register(locationCell, forCellWithReuseIdentifier: SettingsLocationViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
    }
    
    // MARK: - button taps
    
    @IBAction func metricsTapped(_ sender: Any) {
        if metricsButton.isSelected {
            return
        }
        
        setButtonSelected(button: metricsButton)
        setButtonDeselected(button: imperialButton)
    }
    
    @IBAction func imperialTapped(_ sender: Any) {
        if imperialButton.isSelected {
            return
        }
        
        setButtonSelected(button: imperialButton)
        setButtonDeselected(button: metricsButton)
    }
    
    // MARK: - Conditions and final changes
        
    @IBAction func doneTapped(_ sender: Any) {
        var newConditions: [Condition] = []
        
        for condition in conditions {
            switch condition.type {
            case .humidity:
                newConditions.append(.init(type: .humidity, selected: humidityButton.isChecked))
            case .wind:
                newConditions.append(.init(type: .wind, selected: windButton.isChecked))
            case .pressure:
                newConditions.append(.init(type: .pressure, selected: pressureButton.isChecked))
            }
        }
        
        defaultsManager.choosenConditions = newConditions
        
        self.dismiss(animated: true, completion: nil)
        delegate?.didCloseSettings()
    }
    
    // MARK: - Units changes
    
    private func setButtonSelected(button: UIButton){
        button.isSelected = true
        button.setImage(UIImage(named : "square_check"), for: .normal)
        
        if button == metricsButton {
            defaultsManager.units = "metric"
        } else {
            defaultsManager.units = "imperial"
        }
    }
    
    private func setButtonDeselected(button: UIButton){
        button.isSelected = false
        button.setImage(UIImage(named : "square_uncheck"), for: .normal)
    }
    
}

// MARK: - Location and collection methods


extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private func deleteLocation(id: Int){
        var savedLocations = defaultsManager.choosenLocations ?? []
        savedLocations = savedLocations.filter{$0.id != id}
        defaultsManager.choosenLocations = savedLocations
        locations = savedLocations
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingsLocationViewCell.identifier, for: indexPath) as! SettingsLocationViewCell
        
        let location = locations[indexPath.row]
        cell.setup(location: location)
        
        cell.deleteSelected = { [weak self] id in
            self?.deleteLocation(id: id)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 33)
    }
    
}
