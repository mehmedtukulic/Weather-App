//
//  ViewController.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 17/04/2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigateToHomeScreen()
    }
 
    private func navigateToHomeScreen(){
        let vc = HomeViewController()
        self.navigationController?.setViewControllers([vc], animated: true)
    }

}

