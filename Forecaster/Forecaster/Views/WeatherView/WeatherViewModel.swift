//
//  WeatherViewModel.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import Foundation
import SwiftUICore

class WeatherViewModel: NSObject, ObservableObject {
    
   @State var shouldAskForTodo: Bool = false
    
    var todayWeatherDetails: TodaysWeatherDetails
    @Published var forecastData: [ForecastList] = []
    
    init(weatherDetails: TodaysWeatherDetails,
         weatherForcast: [ForecastList]) {
        
        self.todayWeatherDetails = weatherDetails
        self.forecastData = weatherForcast
    }
    
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
    
    func setupViewTheme() -> WeatherViewStyler {
        switch self.todayWeatherDetails.id {
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
