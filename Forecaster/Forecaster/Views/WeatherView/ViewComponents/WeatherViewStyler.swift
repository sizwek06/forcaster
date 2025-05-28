//
//  WeatherViewStyler.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/25.
//

import SwiftUICore

extension WeatherView {
    
    // MARK: - View Styling
    func getForecastCellWeatherIcon(weatherId: Int) -> String {
        
        switch weatherId {
        case 200...799:
            return "rain"
        case 800...899:
            return "partlysunny"
        default:
            return "clear"
        }
    }
    
    func getToolBarWeatherIcon() -> String {
        
        if let todayWeatherDetails = self.viewModel.todayWeatherDetails {
            switch todayWeatherDetails.id {
            case 200...799:
                return self.isWeatherShowing ? "cloud.rain.fill" : "cloud.rain"
            case 800...899:
                return self.isWeatherShowing ? "cloud.sun.fill" : "cloud.sun"
            default:
                return self.isWeatherShowing ? "cloud.sun.bolt.fill" : "cloud.sun.bolt"
            }
        } else {
            return self.isWeatherShowing ? "cloud.sun.bolt.fill" : "cloud.sun.bolt"
        }
    }
    
    func setupViewTheme() -> WeatherViewStyler {
        
        if let todayWeatherDetails = self.viewModel.todayWeatherDetails {
            switch todayWeatherDetails.id {
            case 200...799:
                return WeatherViewStyler(backgroundImage: "rainyStackColor",
                                         mainImage: "sea_rainy",
                                         currentCondition: "Rainy",
                                         backgroundColor: Color.rainyStackColor)
            case 800...899:
                return WeatherViewStyler(backgroundImage: "cloudyStackColor",
                                         mainImage: "sea_cloudy",
                                         currentCondition: "Cloudy",
                                         backgroundColor: Color.cloudyStackColor)
            default:
                return WeatherViewStyler(backgroundImage: "cloudyStackColor",
                                         mainImage: "sea_sunnypng",
                                         currentCondition: "Sunny",
                                         backgroundColor: Color.clearStackColor)
            }
        } else {
            return WeatherViewStyler(backgroundImage: "cloudyStackColor",
                                     mainImage: "sea_sunnypng",
                                     currentCondition: "Sunny",
                                     backgroundColor: Color.clearStackColor)
        }
    }
}
