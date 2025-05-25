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
        
        switch viewModel.todayWeatherDetails.id {
        case 200...799:
            return self.isWeatherShowing ? "cloud.rain.fill" : "cloud.rain"
        case 800...899:
            return self.isWeatherShowing ? "cloud.sun.fill" : "cloud.sun"
        default:
            return self.isWeatherShowing ? "sun.horizon.fill" : "sun.horizon"
        }
    }
    
    func setupViewTheme() -> WeatherViewStyler {
        switch viewModel.todayWeatherDetails.id {
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
    }
}
