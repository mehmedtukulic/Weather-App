//
//  DeviceManager.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 26. 4. 2021..
//

import Foundation
import UIKit

class DeviceManager {
    
    //Returns true if device is iphone 5,6,7,8
    public static func isSmallScreen() -> Bool {
        if UIScreen.main.nativeBounds.height < 1335 {
            return true
        } else {
            return false
        }
    }
    
    public static func isMiddleSizeScreen() -> Bool {
        if (UIScreen.main.nativeBounds.height > 1335) && (UIScreen.main.nativeBounds.height < 2437) {
            return true
        } else {
            return false
        }
    }
}
