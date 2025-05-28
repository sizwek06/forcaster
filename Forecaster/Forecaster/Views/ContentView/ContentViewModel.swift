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
    @Published var viewState: ViewState = .launch
    
    var weatherViewModel: WeatherViewModel?
    var weatherDetails: TodaysWeatherDetails?
    
    @FetchRequest(sortDescriptors: []) private var forecastFetchedResults: FetchedResults<CityForecast>
    
    var errorDescription: String?
    var errorCode: String?
    
    var locationManager: CLLocationManager!
    let apiClient: WeatherApiProtocol!
    
    @Published var forecastData: [ForecastList] = []
    
    public init(apiClient: WeatherApiProtocol = WeatherApiClient(),
                locationManager: CLLocationManager = CLLocationManager(),
                viewState: ViewState = .loading) {
        
        self.apiClient = apiClient
        self.locationManager = CLLocationManager()
        self.viewState = viewState
    }
    
    func getCurrentWeather() async {
    let endpoint = WeatherEndpoints.getCurrent

    do {
        let weather = try await apiClient.asyncRequest(endpoint: endpoint, responseModel: OpenWeather.self)
        
            await MainActor.run {
                self.weatherDetails = TodaysWeatherDetails(city: weather.name,
                                                           minTemperature: weather.main.lowDescription,
                                                           currentTemperature: weather.main.currentTemp,
                                                           maxTemperature: weather.main.highDescription,
                                                           id: weather.weather.first?.id ?? 800,
                                                           dt: weather.dt,
                                                           lat: weather.coord.lat,
                                                           lon: weather.coord.lon)
                
                self.viewState = .loading
                self.showingError = false
            }
        } catch let error as WeatherError {
            await MainActor.run {
                self.showingError = true
                self.errorDescription = error.errorDescription
                self.errorCode = String(error.errorCode)
                
                self.viewState = .error
            }
        } catch {
            await MainActor.run {
                self.showingError = true
                self.errorDescription = "Something went wrong"
                self.errorCode = "0"
                self.viewState = .error
            }
        }
    }
    
    func getWeatherForecast() async {
        let endpoint = WeatherEndpoints.getForecast
        
        do {
            let forecast = try await apiClient.asyncRequest(endpoint: endpoint, responseModel: Forecast.self)
            
            await MainActor.run {
                self.forecastData = forecast.list
                
                self.viewState = .weatherReceived
                self.showingError = false
            }
        } catch let error as WeatherError {
            await MainActor.run {
                self.showingError = true
                self.errorDescription = error.errorDescription
                self.errorCode = String(error.errorCode)
                
                self.viewState = .error
            }
        } catch {
            await MainActor.run {
                self.showingError = true
                self.errorDescription = "Something went wrong"
                self.errorCode = "0"
                self.viewState = .error
            }
        }
    }
    
    func getWeather() async {
        
        guard let locationManager = locationManager.location else {
            self.viewState = .weatherReceived
            self.showingError = false
            
            return
        }
        
        WeatherLocation.sharedInstance.lon = locationManager.coordinate.longitude
        WeatherLocation.sharedInstance.lat = locationManager.coordinate.latitude
        
        await self.getCurrentWeather()
        await self.getWeatherForecast()
    }
    
    func setupLocationDefaultError() {
        self.errorCode = "Location not found.".uppercased()
        self.errorDescription = "Please review device's location settings and restart app.".uppercased()
        
        viewState = .error
    }
    
    func checkLocationStatus() -> ViewState {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways, .authorized:
            return .loading
        default:
            return .loading
        }
    }
    
    func createFiveDayForecast() -> [ForecastList] {
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
                break
            }
        }
        
        return tempArray
    }
}

enum ViewState: Equatable {
    case loading
    case launch
    case weatherReceived
    case locationUnknown
    case error
}
