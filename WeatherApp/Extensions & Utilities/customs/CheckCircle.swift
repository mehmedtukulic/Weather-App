//
//  CheckCircle.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 29. 4. 2021..
//

import Foundation
import UIKit

class CheckCircle: UIButton {
    // Images
    let checkedImage = UIImage(named: "circle_check")
    let uncheckedImage = UIImage(named: "circle_uncheck")
    
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
        
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        isChecked = false
        layer.cornerRadius = frame.height/2
    }
        
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
