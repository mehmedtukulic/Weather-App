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
 
    private var locationManager: WeatherLocationManager?
    private var defaultsManager = DefaultsManager()
    
    private var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        if let _ = defaultsManager.lastLocationChoosen{
            viewModel.getWeatherForLastLocation()
        } else {
            getCurrentLocation()
        }
        
        setupBindings()
        setupScreen()
        setupBlur()
    }
    
    private func setupBindings(){
        viewModel.modelChanged = { [weak self] in
            guard let self = self else {return}
            
            print(self.viewModel.weatherModel.name)
        }
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

// MARK: - Search Delegate

extension HomeViewController: SearchDelegate {
    func didClose() {
        hideBlurWithAnimation()
    }
    
    func didChooseLocation() {
        
    }
}

// MARK: - Location manager

extension HomeViewController: CLLocationManagerDelegate {
    private func getCurrentLocation(){
        locationManager = WeatherLocationManager(delegate: self)
        locationManager?.determineMyCurrentLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //After setting the location, stop from updating
        if viewModel.currentLocation != nil {
            locationManager = nil
            return
        }
        
        //Get weather for the users location
        viewModel.currentLocation = locations.last! as CLLocation
        viewModel.getWeatherForCurrentLocation()
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied {
            //User haven't allowed location, get weather for default location
            viewModel.getWeatherForLastLocation()
        }
    }
}
