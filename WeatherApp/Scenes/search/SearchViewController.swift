//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 23. 4. 2021..
//

import UIKit

protocol SearchDelegate: class{
    func didClose()
    func didChooseLocation(model: WeatherModel)
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBottomConstraint: NSLayoutConstraint!
    
    private var spinner: UIActivityIndicatorView!
    private var isSpinning: Bool = false
    
    weak var delegate: SearchDelegate?
    private var viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupBindings()
        setupScreen()
        setupCollection()
    }
    
    private func setupBindings(){
        viewModel.locations.bind{[weak self] _ in
            self?.collectionView.reloadData()
        }
        
        viewModel.isLoading.bind{[weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    private func setupScreen(){
        searchTextField.becomeFirstResponder()
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(searchTermChanged), for: .editingChanged)
        
        
        containerView.backgroundColor = .clear
        closeButton.layer.cornerRadius = 16
    }
    
    private func setupCollection(){
        let locationCell = UINib(nibName: "LocationViewCell", bundle: nil)
        collectionView.register(locationCell, forCellWithReuseIdentifier: LocationViewCell.identifier)
        
        let infoCell = UINib(nibName: "SearchInfoViewCell", bundle: nil)
        collectionView.register(infoCell, forCellWithReuseIdentifier: SearchInfoViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
    }
    
    private func startSpinner(){
        spinner = UIActivityIndicatorView(style: .large)
        
        let spinnerView = UIView()
        spinnerView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        isSpinning = true
    }
    
    private func stopSpinner(){
        spinner.stopAnimating()
        isSpinning = false
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.didClose()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            searchBottomConstraint.constant = keyboardSize.height + 10
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        searchBottomConstraint.constant = 40
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SearchViewController: UITextFieldDelegate {
    @objc func searchTermChanged(){
        if let term = searchTextField.text{
            viewModel.updateSearchTerm(term: term)
        }
    }
}

// MARK: - Collection methods

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.isLoading.value {
            return 1
        }
        
        //Check is there no locations
        if viewModel.locations.value.count == 0 && searchTextField.text!.count >= 3{
            return 1
        }
        
        return viewModel.locations.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationViewCell.identifier, for: indexPath) as! LocationViewCell
        let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchInfoViewCell.identifier, for: indexPath) as! SearchInfoViewCell
        
        //If the loactions are loading, show loading info
        if viewModel.isLoading.value {
            infoCell.setLoading()
            return infoCell
        }
        
        //If there is no locations after loading, show no location info
        if viewModel.locations.value.count == 0 && searchTextField.text!.count >= 3{
            infoCell.setNoLocations()
            return infoCell
        }
        
        let location = viewModel.locations.value[indexPath.row]
        cell.setup(location: location)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //User selected location, waiting for backend
        if isSpinning{
            return
        }
        
        startSpinner()
        
        let selectedLocation = viewModel.locations.value[indexPath.row]
        
        //Get previously choosen locations
        if var savedLocations = DefaultsManager().choosenLocations {
            
            //If this location was alredy choosen, remove it
            if savedLocations.contains(where: {$0.id == selectedLocation.id}){
                savedLocations = savedLocations.filter{$0.id != selectedLocation.id}
            }
            
            let city = selectedLocation.name
            let country = selectedLocation.countryCode.lowercased()
            
            WeatherWorker().getWeather(cityName: city, countryCode: country) { [weak self] (model) in
                guard let self = self else {return}
                
                //If there is no result, just dismiss the vc
                if !model.weather.isEmpty {
                    self.delegate?.didChooseLocation(model: model)
                    
                    //Insert new location on the first place
                    savedLocations.insert(selectedLocation, at: 0)
                    //Replace old locations with new array
                    DefaultsManager().choosenLocations = savedLocations
                }
                
                self.dismiss(animated: true, completion: nil)
                self.delegate?.didClose()
                
            } failure: { [weak self] (error) in
                self?.stopSpinner()
                self?.dismiss(animated: true, completion: nil)
                self?.delegate?.didClose()
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    
}
