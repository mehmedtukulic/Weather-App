//
//  DefaultsManager.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 25. 4. 2021..
//

import Foundation

class DefaultsManager{
    var firstLogin: Bool? {
        set(value) {
            UserDefaults.standard.set(value, forKey: "firstLogin")
        }
        get {
            return UserDefaults.standard.bool(forKey: "firstLogin")
        }
    }
    
    var lastLocationChoosen: String? {
        set(value) {
            UserDefaults.standard.set(value, forKey: "lastLocation")
        }
        get {
            return UserDefaults.standard.string(forKey: "lastLocation")
        }
    }
}
