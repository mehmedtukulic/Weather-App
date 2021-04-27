//
//  SearchInfoViewCell.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 28. 4. 2021..
//

import UIKit

class SearchInfoViewCell: UICollectionViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = false
    }
    
    func setLoading(){
        infoLabel.text = "Searching..."
    }
    
    func setNoLocations(){
        infoLabel.text = "No locations found :("
    }
}
