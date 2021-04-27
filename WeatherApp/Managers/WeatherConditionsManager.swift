//
//  WeatherConditionsManager.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 25. 4. 2021..
//

import Foundation
import UIKit
import UIGradient

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
        //partly cloudy
        case 801:
            if icon.contains("d"){
                //partly cloudy and cloudy have the same body
                let bodyImage = UIImage(named: "body_cloudy_day") ?? UIImage()
                let headerImage = UIImage(named: "header_partly_cloudy_day") ?? UIImage()
                return (headerImage,bodyImage)
            }

            let bodyImage = UIImage(named: "body_cloudy_night") ?? UIImage()
            let headerImage = UIImage(named: "header_partly_cloudy_night") ?? UIImage()
            return (headerImage,bodyImage)
        default:
            //cloudy
            let headerImage = UIImage(named: "header_cloudy") ?? UIImage()
            
            //if its cloudy, take partly cloudy body based on day/night
            if icon.contains("d"){
                let bodyImage = UIImage(named: "body_cloudy_day") ?? UIImage()
                return (headerImage,bodyImage)
            }
            
            //cloudy and partly cloudy have
            let bodyImage = UIImage(named: "body_cloudy_night") ?? UIImage()
            return (headerImage,bodyImage)
        }
    }
    
    
    func getWeatherGradient(weather: WeatherModel.Weather) -> GradientLayer{
        //Rain, snow and fog have its custom colors
        //Other weathers colors depends on day/night
        
        switch weather.id {
        //rain
        case 300...321:
            return GradientLayer(direction: .topToBottom, colors: [.rainTop,.rainBottom])
        //rain
        case 500...531:
            return GradientLayer(direction: .topToBottom, colors: [.rainTop,.rainBottom])
        //snow
        case 600...622:
            return GradientLayer(direction: .topToBottom, colors: [.snowTop,.snowBottom])
        //fog
        case 741:
            return GradientLayer(direction: .topToBottom, colors: [.fogTop,.fogBottom])
        //others
        default:
            //night
            if weather.icon.contains("n") {
                return GradientLayer(direction: .topToBottom, colors: [.nightTop,.nightBottom])
            } else {
                //day
                return GradientLayer(direction: .topToBottom, colors: [.dayTop,.dayBottom])
            }
        }
        
    }
}

extension WeatherConditionsManager {
    func temperatureInFahrenheit(temperature: Double) -> Double {
          let fahrenheitTemperature = temperature * 9 / 5 + 32
          return fahrenheitTemperature.rounded(toPlaces: 1)
    }
}
