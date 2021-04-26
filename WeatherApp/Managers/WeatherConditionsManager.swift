//
//  WeatherConditionsManager.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 25. 4. 2021..
//

import Foundation
import UIKit

class WeatherConditionsManager{
    
    func getWeatherImages(weather: WeatherModel.Weather) -> (header: UIImage, body: UIImage){
        
        switch weather.id {
        case 200...232:
            return getThunderStormImages()
        case 300...321:
            return getRainImages()
        case 500...531:
            return getRainImages()
        case 600...622:
            return getSnowImages(id: weather.id)
        case 701...781:
            return getAtmosphereImages(id: weather.id)
        case 800:
            return getClearImages(icon: weather.icon)
        case 801...804:
            return getCloudyImages(id: weather.id, icon: weather.icon)
        default:
            return getClearImages(icon: weather.icon)
        }
    }
    
    func getThunderStormImages() -> (header: UIImage, body: UIImage) {
        let headerImage = UIImage(named: "header_thunderstorm") ?? UIImage()
        let bodyImage = UIImage(named: "body_thunderstorm") ?? UIImage()
        return (headerImage,bodyImage)
    }
    
    func getRainImages() -> (header: UIImage, body: UIImage) {
        let headerImage = UIImage(named: "header_rain") ?? UIImage()
        let bodyImage = UIImage(named: "body_rain") ?? UIImage()
        return (headerImage,bodyImage)
    }
    
    func getSnowImages(id: Int) -> (header: UIImage, body: UIImage) {
        
        switch id {
        case 211...213:
            let headerImage = UIImage(named: "header_sleet") ?? UIImage()
            let bodyImage = UIImage(named: "body_sleet") ?? UIImage()
            return (headerImage,bodyImage)
        default:
            let headerImage = UIImage(named: "header_snow") ?? UIImage()
            let bodyImage = UIImage(named: "body_snow") ?? UIImage()
            return (headerImage,bodyImage)
        }
    }
    
    func getAtmosphereImages(id: Int) -> (header: UIImage, body: UIImage) {
        let bodyImage = UIImage(named: "body_tornado") ?? UIImage()
        
        switch id {
        case 781:
            let headerImage = UIImage(named: "header_tornado") ?? UIImage()
            return (headerImage,bodyImage)
        default:
            let headerImage = UIImage(named: "header_fog") ?? UIImage()
            return (headerImage,bodyImage)
        }

    }
    
    func getClearImages(icon: String) -> (header: UIImage, body: UIImage){
        
        switch icon {
        case "01d":
            let headerImage = UIImage(named: "header_clear_day") ?? UIImage()
            let bodyImage = UIImage(named: "body_clear_day") ?? UIImage()
            return (headerImage,bodyImage)
        default:
            let headerImage = UIImage(named: "header_clear_night") ?? UIImage()
            let bodyImage = UIImage(named: "body_clear_night") ?? UIImage()
            return (headerImage,bodyImage)
        }
    }
    
    
    func getCloudyImages(id: Int, icon: String) -> (header: UIImage, body: UIImage) {
        
        switch id {
        case 801:
            if icon == "02d"{
                let bodyImage = UIImage(named: "body_partly_cloudy_day") ?? UIImage()
                let headerImage = UIImage(named: "header_partly_cloudy_day") ?? UIImage()
                return (headerImage,bodyImage)
            }
            
            let bodyImage = UIImage(named: "body_partly_cloudy_night") ?? UIImage()
            let headerImage = UIImage(named: "header_partly_cloudy_night") ?? UIImage()
            return (headerImage,bodyImage)
            
        default:
            let bodyImage = UIImage(named: "body_cloudy") ?? UIImage()
            let headerImage = UIImage(named: "header_cloudy") ?? UIImage()
            return (headerImage,bodyImage)
        }
    }
}
