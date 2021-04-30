//
//  DefaultsManager.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 25. 4. 2021..
//

import Foundation

class DefaultsManager{
  
    var units: String? {
        set(value) {
            UserDefaults.standard.set(value, forKey: "units")
        }
        get {
            return UserDefaults.standard.string(forKey: "units")
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
    
    var choosenConditions: [Condition]? {
        set(value) {
            do {
                try UserDefaults.standard.setObject(value, forKey: "choosenConditions")
            } catch {
                print(error.localizedDescription)
            }
        }
        get {
            do {
                let locations = try UserDefaults.standard.getObject(forKey: "choosenConditions", castTo: [Condition].self)
                return locations
            } catch {
                print(error.localizedDescription)
            }
            
            return []
        }
    }

}
