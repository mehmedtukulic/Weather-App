//
//  ViewController.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 17/04/2021.
//

import UIKit

class ViewController: UIViewController {
    
    let defaultsManager = DefaultsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //If it's first login, set initial value
        if let conditions = defaultsManager.choosenConditions, !conditions.isEmpty{
            navigateToHomeScreen()
        } else {
            setInitialValues()
            navigateToHomeScreen()
        }

    }
    
    private func setInitialValues(){
        defaultsManager.units = "metric"
        
        var conditions: [Condition] = []
        let humidity: Condition = Condition(type: .humidity, selected: true)
        let wind: Condition = Condition(type: .wind, selected: true)
        let pressure: Condition = Condition(type: .pressure, selected: true)
        
        conditions.append(contentsOf: [humidity,wind,pressure])
        defaultsManager.choosenConditions = conditions
    }
 
    private func navigateToHomeScreen(){
        let vc = HomeViewController()
        self.navigationController?.setViewControllers([vc], animated: true)
    }

}

