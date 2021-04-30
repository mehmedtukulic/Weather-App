//
//  ConditionModel.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 29. 4. 2021..
//

import Foundation

struct Condition: Codable {
    let type: ConditionType
    let selected: Bool
    
    enum CodingKeys: String, CodingKey {
        case type,selected
    }
}

enum ConditionType{
    case humidity
    case wind
    case pressure
}

extension ConditionType: Codable {
    
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .humidity
        case 1:
            self = .wind
        case 2:
            self = .pressure
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .humidity:
            try container.encode(0, forKey: .rawValue)
        case .wind:
            try container.encode(1, forKey: .rawValue)
        case .pressure:
            try container.encode(2, forKey: .rawValue)
        }
    }
    
}
