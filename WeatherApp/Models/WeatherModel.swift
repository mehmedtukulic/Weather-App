//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 25. 4. 2021..
//

import Foundation

struct WeatherModel: Codable {
    let name: String
    let weather: [Weather]
    let mainInfo: MainInfo
    let wind: Wind
    
    enum CodingKeys: String, CodingKey {
        case name,weather,wind
        case mainInfo = "main"
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let descriptionInfo: String
        let icon: String
        
        enum CodingKeys: String, CodingKey {
            case id,main,icon
            case descriptionInfo = "description"
        }
    }
    
    struct MainInfo: Codable {
        let temp: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Double
        let humidity: Double
        
        enum CodingKeys: String, CodingKey {
            case temp = "temp"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure,humidity
        }
    }
    
    struct Wind: Codable {
        let speed: Double
       
        enum CodingKeys: String, CodingKey {
            case speed = "speed"
        }
    }
}
