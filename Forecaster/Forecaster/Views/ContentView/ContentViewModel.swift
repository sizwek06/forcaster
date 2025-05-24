//
//  ContentViewModel.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import Foundation
import SwiftUI
import CoreLocation

class ContentViewModel: NSObject, ObservableObject {
    
    @Published var currentTemp = "0"
    @Published var minTemp = "0"
    @Published var maxTemp = "0"
    
    @Published var showingError = false
    @Published var viewState: ViewState = .loading
    
    var weatherViewModel: WeatherViewModel?
    var weatherDetails: TodaysWeatherDetails?
    
    var errorDescription: String?
    var errorCode: String?
    
    let locationManager: CLLocationManager!
    let apiClient: WeatherApiProtocol!
    
    var dt: String?
    
    @Published var forecastData: [ForecastList] = []
    
    public init(apiClient: WeatherApiProtocol = WeatherApiClient(),
                locationManager: CLLocationManager = CLLocationManager()) {
        
        self.apiClient = apiClient
        self.locationManager = CLLocationManager()
    }
    
    func getCurrentWeather() async {
        let endpoint = WeatherEndpoints.getCurrent
        
        Task {
            do {
                let weather = try await apiClient.asyncRequest(endpoint: endpoint, responseModel: OpenWeather.self)
        
                self.weatherDetails = TodaysWeatherDetails(city: weather.name,
                                                          minTemperature: weather.main.currentTemp,
                                                          currentTemperature: weather.main.lowDescription,
                                                           maxTemperature: weather.main.highDescription,
                                                           id: weather.weather.first?.id ?? 800)
                
                await MainActor.run {
                    print("Current weather: \(self.forecastData)")
                    self.dt = weather.date
                    self.viewState = .weatherReceived
                }
            } catch let error as WeatherError {
                await MainActor.run {
                    self.showingError = true
                    self.errorDescription = error.errorDescription
                }
            }
        }
    }
    
    func getWeatherForecast() async {
        let endpoint = WeatherEndpoints.getForecast
        
        Task {
            do {
                let forecast = try await apiClient.asyncRequest(endpoint: endpoint, responseModel: Forecast.self)
                
                await MainActor.run {
                    
                    self.forecastData = forecast.list
                    print("Current Array: \(self.forecastData)")
                    
                    self.viewState = .weatherReceived
                }
            } catch let error as WeatherError {
                await MainActor.run {
                    self.showingError = true
                    self.errorDescription = error.errorDescription
                }
            }
        }
    }
    
    func getWeather() async {
        guard let locationManager = locationManager.location else {
            self.setupLocationDefaultError()
            return
        }
        
        WeatherLocation.sharedInstance.long = locationManager.coordinate.longitude.description
        WeatherLocation.sharedInstance.lat = locationManager.coordinate.latitude.description
        
        await self.getCurrentWeather()
        await self.getWeatherForecast()
    }
    
    func setupLocationDefaultError() {
        self.errorCode = "Location not found.".uppercased()
        self.errorDescription = "Rlease review device's location settings and restart app.".uppercased()
    }
    
    func checkLocationStatus() -> ViewState {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways, .authorized:
            return .loading
        default:
            return .locationUnknown
        }
    }
    
    func createFiveDayForecast() -> [ForecastList] {
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
                break
            }
        }
        
        return tempArray
    }
}

enum ViewState: Equatable {
    case loading
    case weatherReceived
    case locationUnknown
}
