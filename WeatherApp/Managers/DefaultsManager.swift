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
    
    var choosenLocations: [Location]? {
        set(value) {
            do {
                try UserDefaults.standard.setObject(value, forKey: "choosenLocations")
            } catch {
                print(error.localizedDescription)
            }
        }
        get {
            do {
                let locations = try UserDefaults.standard.getObject(forKey: "choosenLocations", castTo: [Location].self)
                return locations
            } catch {
                print(error.localizedDescription)
            }
            
            return []
        }
    }
}
