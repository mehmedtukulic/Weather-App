//
//  WeatherConditionsManager.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 25. 4. 2021..
//

import Foundation
import UIKit

enum WeatherTypes {
    case thunderstorm
    case drizzle
    case rain
    case snow
    case atmosphere
    case clear
    case clouds
}

class WeatherConditionsManager{
    
    func getWeatherImages(weather: WeatherModel.Weather) -> (header: UIImage, body: UIImage){
        
        switch weather.id {
        case 0...100:
            return (UIImage(),UIImage())
        default:
            return (UIImage(),UIImage())
        }
    }
}
