//
//  UIViewController+Extra.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 30. 4. 2021..
//

import Foundation
import UIKit

extension UIViewController {
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: 48, y: self.view.frame.size.height/2 - 35, width: self.view.frame.width - 96, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 16)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
