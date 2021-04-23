//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 23. 4. 2021..
//

import UIKit

protocol SearchDelegate: class{
    func didClose()
    func didChooseLocation()
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    weak var delegate: SearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.backgroundColor = .clear
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.didClose()
    }
}
