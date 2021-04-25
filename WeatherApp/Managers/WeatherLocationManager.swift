//
//  WeatherLocationManager.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 25. 4. 2021..
//

import Foundation
import CoreLocation

class WeatherLocationManager {
    
    var locationManager : CLLocationManager!
    var delegate: CLLocationManagerDelegate?
    
    required init(delegate: CLLocationManagerDelegate) {
        self.delegate = delegate
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = delegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            locationManager.startUpdatingLocation()
        }
    }

}
