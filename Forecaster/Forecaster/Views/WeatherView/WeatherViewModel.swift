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
}
