//
//  WeatherViewModel.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import Foundation
import SwiftUICore
import CoreData
import SwiftUI

class WeatherViewModel: NSObject, ObservableObject {
    
    @Published var todayWeatherDetails: TodaysWeatherDetails?
    @Published var forecastData: [ForecastList] = []
    
    var errorDescription: String?
    var errorCode: String?
    
    let apiClient: WeatherApiProtocol!
    
    init(apiClient: WeatherApiProtocol = WeatherApiClient(),
         weatherDetails: TodaysWeatherDetails? = nil,
         weatherForcast: [ForecastList]) {
        
        self.apiClient = apiClient
        self.todayWeatherDetails = weatherDetails
        self.forecastData = weatherForcast
    }
    
    // MARK: - API Requests Functionality
    func getCityCurrentWeather() async {
        
        let endpoint = WeatherEndpoints.getCityCurrent
        
        Task {
            do {
                let weather = try await apiClient.asyncRequest(endpoint: endpoint, responseModel: OpenWeather.self)
                
                await MainActor.run {
                    self.todayWeatherDetails = TodaysWeatherDetails(city: weather.name,
                                                                    minTemperature: weather.main.lowDescription,
                                                                    currentTemperature: weather.main.currentTemp,
                                                                    maxTemperature: weather.main.highDescription,
                                                                    id: weather.weather.first?.id ?? 800,
                                                                    dt: weather.dt,
                                                                    lat: weather.coord.lat,
                                                                    lon: weather.coord.lon)
                    
                    print("Current weather: \(self.forecastData)")
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
            if existingDays.contains(forecast.dt.dayOfWeekString) {
                
                tempArray[tempArray.count - 1] = forecast
                
                if let index = tempArray.firstIndex(where: { $0.dt.dayOfWeekString == forecast.dt.dayOfWeekString }) {
                    tempArray[index] = forecast
                }
            } else {
                tempArray.append(forecast)
                existingDays.insert(forecast.dt.dayOfWeekString)
            }
            
            if tempArray.count == 6 {
                tempArray.remove(at: 0)
                print("WeatherViewModel Array: \(tempArray)")
                self.forecastData = tempArray
                break
            }
        }
    }
}
