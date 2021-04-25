//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 20. 4. 2021..
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    
    private var visualEffectView: UIVisualEffectView!
    private var currentLocation: CLLocation?
    
    private var locationManager: WeatherLocationManager?
    private var defaultsManager = DefaultsManager()
    private var weatherWorker = WeatherWorker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        if let _ = defaultsManager.lastLocationChoosen{
            getWeatherForLastLocation()
        } else {
            getCurrentLocation()
        }
        
        setupScreen()
        setupBlur()
    }
    
    @IBAction func settingsTapped(_ sender: Any) {
        
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        let vc = SearchViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
        visualEffectView.isHidden = false
        visualEffectView.alpha = 0.9
    }
    
    private func setupScreen(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchTapped(_:)))
        searchView.backgroundColor = .white
        searchView.isUserInteractionEnabled = true
        searchView.addGestureRecognizer(tap)
        searchView.layer.cornerRadius = 20
        
    }
    
    private func setupBlur(){
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.navigationController?.view.frame ?? CGRect.zero
        visualEffectView.effect = UIBlurEffect(style: .light)
        visualEffectView.alpha = 0
        self.view.addSubview(visualEffectView)
    }
    
    private func hideBlurWithAnimation(){
        UIView.animate(withDuration: 1) {
            self.visualEffectView.alpha = 0
        }
    }
    
}


extension HomeViewController: SearchDelegate {
    func didClose() {
        hideBlurWithAnimation()
    }
    
    func didChooseLocation() {
        
    }
}


// MARK: - location setup

extension HomeViewController {
    private func getCurrentLocation(){
        locationManager = WeatherLocationManager(delegate: self)
        locationManager?.determineMyCurrentLocation()
    }
    
    private func getWeatherForLastLocation(){
        let city = defaultsManager.lastLocationChoosen ?? "London"
        
        weatherWorker.getWeather(cityName: city) { (vrijeme) in
            print("")
        } failure: { (error) in
            print(error)
        }
    }
    
    private func getWeatherForCurrentLocation(){
        let lat = currentLocation!.coordinate.latitude
        let lon = currentLocation!.coordinate.longitude
        
        weatherWorker.getWeather(lat: lat, lon: lon) { (vrijeme) in
            print("")
        } failure: { (error) in
            print("error")
        }
    }
    
}

// MARK: - Location manager

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Stop Location from updating
        if currentLocation != nil {
            locationManager = nil
            return
        }
        
        //Get only users first location
        currentLocation = locations.last! as CLLocation
        
        getWeatherForCurrentLocation()
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if manager.authorizationStatus == .denied {
            //User haven't allowed location, get weather for default location
            getWeatherForLastLocation()
        }
    }
}
