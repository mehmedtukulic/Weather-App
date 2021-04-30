//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 25. 4. 2021..
//

import Foundation
import UIKit
import CoreLocation

class HomeViewModel {
    
    var modelChanged: (() -> Void)?
    
    var weatherModel: WeatherModel! {
        didSet {
            modelChanged?()
        }
    }
    
    var currentLocation: CLLocation?
    private var defaultsManager = DefaultsManager()
    private var weatherConditionsManager = WeatherConditionsManager()
    private var weatherWorker = WeatherWorker()
    
}

// MARK: - API Calls
extension HomeViewModel {
   
    func getWeatherForLastLocation(){
        let city = defaultsManager.choosenLocations?.first?.name ?? "Sarajevo"
        let country = defaultsManager.choosenLocations?.first?.countryCode.lowercased() ?? "ba"
        
        weatherWorker.getWeather(cityName: city, countryCode: country) { [weak self] (model) in
            self?.weatherModel = model
            
            
        } failure: { (error) in
            print(error)
        }
    }
    
    func getWeatherForCurrentLocation(){
        let lat = currentLocation!.coordinate.latitude
        let lon = currentLocation!.coordinate.longitude
        
        weatherWorker.getWeather(lat: lat, lon: lon) { [weak self] (model) in
            self?.weatherModel = model
            
        } failure: { (error) in
            print(error)
        }
    }
}

