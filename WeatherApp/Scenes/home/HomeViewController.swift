//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 20. 4. 2021..
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    
    private var visualEffectView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        self.navigationController?.navigationBar.isHidden = true
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
