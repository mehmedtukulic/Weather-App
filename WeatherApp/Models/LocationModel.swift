//
//  LocationModel.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 28. 4. 2021..
//

import Foundation

struct LocationModel: Codable {
    let locations: [Location]
    
    enum CodingKeys: String, CodingKey {
        case locations = "geonames"
    }
}

struct Location: Codable {
    let id: Int
    let name: String
    let countryCode: String
    
    enum CodingKeys: String, CodingKey {
        case id = "geonameId"
        case countryCode = "countryCode"
        case name
    }
}
