//
//  UICell+Extra.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 28. 4. 2021..
//

import Foundation
import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}


extension UICollectionReusableView {
    static var id: String {
        return String(describing: self)
    }
}
