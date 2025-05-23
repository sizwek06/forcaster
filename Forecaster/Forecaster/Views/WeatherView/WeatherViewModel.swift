//
//  WeatherViewModel.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import Foundation
import SwiftUICore

class WeatherViewModel: NSObject, ObservableObject {
    
    @Published var todayWeatherDetails: TodaysWeatherDetails
    @Published var forecastData: [ForecastList] = []
    @Published var dt: String
    
    var errorDescription: String?
    var errorCode: String?
    
    let apiClient: WeatherApiProtocol!
    
    init(apiClient: WeatherApiProtocol = WeatherApiClient(),
         weatherDetails: TodaysWeatherDetails,
         weatherForcast: [ForecastList],
         dt: String) {
        
        self.apiClient = apiClient
        self.todayWeatherDetails = weatherDetails
        self.forecastData = weatherForcast
        self.dt = dt
    }
    
    func getCityCurrentWeather() async {
        let endpoint = WeatherEndpoints.getCityCurrent
        
        Task {
            do {
                let weather = try await apiClient.asyncRequest(endpoint: endpoint, responseModel: OpenWeather.self)
                
                guard let weatherMain = weather.main else {
                    return
                }
                
                self.todayWeatherDetails = TodaysWeatherDetails(city: weather.name ?? "Land of Ooo",
                                                          minTemperature: weatherMain.currentTemp,
                                                          currentTemperature: weatherMain.lowDescription,
                                                           maxTemperature: weatherMain.highDescription,
                                                           id: weather.weather?.first?.id ?? 800)
                // TODO: Properly Unwrap above values?
                
                await MainActor.run {
                    print("Current weather: \(self.forecastData)")
                    self.dt = weather.date
                }
            } catch let error as WeatherError {
                await MainActor.run {
                    // TODO: Handling Error? Alert?
                    self.errorDescription = error.errorDescription
                }
            }
        }
    }
    
    func getCityWeatherForecast() async {
        let endpoint = WeatherEndpoints.getCityForecast
        
        Task {
            do {
                let forecast = try await apiClient.asyncRequest(endpoint: endpoint, responseModel: Forecast.self)
                
                await MainActor.run {
                    
                    self.forecastData = forecast.list
                    print("Current Array: \(self.forecastData)")
                    self.createFiveDayForecast()
                }
            } catch let error as WeatherError {
                await MainActor.run {
                    // TODO: Handling Error? Alert?
                    self.errorDescription = error.errorDescription
                }
            }
        }
    }
    
    func getCityWeather() async {
        await self.getCityCurrentWeather()
        await self.getCityWeatherForecast()
    }
    
    func createFiveDayForecast() {
        var existingDays = Set<String>()
        var tempArray: [ForecastList] = []
        
        for forecast in self.forecastData {
            if existingDays.contains(forecast.date) {
                
                tempArray[tempArray.count - 1] = forecast
                
                if let index = tempArray.firstIndex(where: { $0.date == forecast.date }) {
                    tempArray[index] = forecast
                }
            } else {
                tempArray.append(forecast)
                existingDays.insert(forecast.date)
            }
            
            if tempArray.count == 6 {
                tempArray.remove(at: 0)
                print("WeatherViewModel Array: \(tempArray)")
                self.forecastData = tempArray
                break
            }
        }
    }
    // TODO: Move above and DRY
    
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
