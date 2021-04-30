//
//  SettingsLocationViewCell.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 30. 4. 2021..
//

import UIKit

class SettingsLocationViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private var locationId: Int!
    var deleteSelected: ((Int) -> Void)?
    
    
    func setup(location: Location){
        titleLabel.text = location.name + "," + " \(location.countryCode)"
        locationId = location.id
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        deleteSelected?(locationId)
    }
    
}
