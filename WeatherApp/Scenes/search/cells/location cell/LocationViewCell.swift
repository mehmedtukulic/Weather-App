//
//  LocationViewCell.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 28. 4. 2021..
//

import UIKit

class LocationViewCell: UICollectionViewCell {

    @IBOutlet weak var firstLetterLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    func setup(location: Location){
        firstLetterLabel.text = String(location.name.prefix(1))
        nameLabel.text = location.name + "," + " \(location.countryCode)"
    }

}
