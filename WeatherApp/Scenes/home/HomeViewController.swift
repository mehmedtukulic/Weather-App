//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 20. 4. 2021..
//

import UIKit
import CoreLocation
import UIGradient

class HomeViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var bodyView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var humidityStack: UIStackView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windStack: UIStackView!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureStack: UIStackView!
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTopConstraint: NSLayoutConstraint!
    
    private var visualEffectView: UIVisualEffectView!
    
    private var locationManager: WeatherLocationManager?
    private var defaultsManager = DefaultsManager()
    private var conditionsManager = WeatherConditionsManager()
    
    private var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        //If user alredy searched for some locations
        if let _ = defaultsManager.choosenLocations?.first{
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
            let model = self.viewModel.weatherModel
            
            let gradient = self.conditionsManager.getWeatherGradient(weather: (model?.weather[0])!)
            self.gradientView.addGradient(gradient)
            
            let weatherImages = self.conditionsManager.getWeatherImages(weather: (model?.weather[0])!)
            self.headerView.image = weatherImages.header
            self.bodyView.image = weatherImages.body
            
            let name = model?.name ?? ""
            let temp = Int(model?.mainInfo.temp ?? 0.0)
            let description = model?.weather[0].main ?? ""
            let minTemp = self.conditionsManager.temperatureInFahrenheit(temperature: model?.mainInfo.tempMin ?? 0.0)
            let maxTemp = self.conditionsManager.temperatureInFahrenheit(temperature: model?.mainInfo.tempMax ?? 0.0)
            let humidity = model?.mainInfo.humidity ?? 0.0
            let pressure = Int(model?.mainInfo.pressure ?? 0.0)
            let wind = model?.wind.speed.rounded(toPlaces: 1) ?? 0.0
            
            self.weatherInfoLabel.text = description
            self.cityLabel.text = name
            self.temperatureLabel.text = ("\(temp)°")
            self.lowTempLabel.text = ("\(minTemp) °F")
            self.highTempLabel.text = ("\(maxTemp) °F")
            self.humidityLabel.text = ("\(humidity)%")
            self.pressureLabel.text = ("\(pressure) hpa")
            self.windLabel.text = ("\(wind) mph")
        
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
        
        if DeviceManager.isSmallScreen() {
            topConstraint.constant = 100
            nameTopConstraint.constant = 60
        }
        
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
    
    private func addGradient(){
        gradientView.addGradientWithDirection(.bottomLeftToTopRight, colors: [.black,.blue])
    }
    
}

// MARK: - Search Delegate

extension HomeViewController: SearchDelegate {
    
    func didClose() {
        hideBlurWithAnimation()
    }
    
    func didChooseLocation(model: WeatherModel) {
        viewModel.weatherModel = model
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
