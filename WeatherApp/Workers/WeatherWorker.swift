//
//  WeatherWorker.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 25. 4. 2021..
//

import Foundation
import Alamofire

class WeatherWorker{
    
    func getWeather(cityName: String? = nil,
                    lat: Double? = nil,
                    lon: Double? = nil,
                    success: @escaping (String) -> Void,
                    failure: @escaping (String)  -> Void) {
        
        let apiKey = "1efe7ac6961a33484d1fb6bc1059e652"
        
        // create url
        var path = "https://api.openweathermap.org/data/2.5/weather?"
        
        if let city = cityName {
            path = path + "q=\(city)"
        }
        
        if let lattitude = lat, let longitude = lon {
            path = path + "lat=\(lattitude)" + "&lon=\(longitude)"
        }
        
        path.append("&appid=\(apiKey)")

        guard let url = URL(string: path) else { return }

        // create request
        let method : HTTPMethod = .get
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        // execute request
        AF.request(request).responseData(completionHandler: {(response) in

            guard let data = response.data else {
                return
            }

            if let statusCode = response.response?.statusCode {
                if statusCode >= 200 && statusCode < 400 {
                    do {
                        // parse result
                       let decoder = JSONDecoder()
                       let object = try decoder.decode(String.self, from: data)
                       success(object)

                    } catch (let error){
                        failure(error.localizedDescription)
                    }
                } else {
                    failure("Something went wrong")
                }

            } else {
                failure("Something went wrong")
            }

        })
    }
}


extension WeatherWorker {
    func getMetrics(){
        
    }
}
