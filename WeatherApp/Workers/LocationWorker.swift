//
//  LocationWorker.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 28. 4. 2021..
//

import Foundation
import Alamofire

class LocationWorker {
    func getLocations(searchTerm: String, success: @escaping (LocationModel) -> Void, failure: @escaping (String)  -> Void) {
        
        let username = "mehmedtukulic"
        
        // create url
        var path = "http://api.geonames.org/searchJSON?name_startsWith=\(searchTerm)&maxRows=5"
        
        path.append("&username=\(username)")

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
                       let object = try decoder.decode(LocationModel.self, from: data)
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
