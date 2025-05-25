//
//  ContentViewModel.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import Foundation
import SwiftUI
import CoreLocation
import CoreData

class ContentViewModel: NSObject, ObservableObject {
    
    @Published var currentTemp = "0"
    @Published var minTemp = "0"
    @Published var maxTemp = "0"
    
    @Published var showingError = false
    @Published var viewState: ViewState = .launch
    
    var weatherViewModel: WeatherViewModel?
    var weatherDetails: TodaysWeatherDetails?
    
    @FetchRequest(sortDescriptors: []) private var cityFetchedResults: FetchedResults<FavouriteCity>
    @FetchRequest(sortDescriptors: []) private var forecastFetchedResults: FetchedResults<CityForecast>
    
    var errorDescription: String?
    var errorCode: String?
    
    let locationManager: CLLocationManager!
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
        
        Task {
            do {
                let weather = try await apiClient.asyncRequest(endpoint: endpoint, responseModel: OpenWeather.self)
        
                self.weatherDetails = TodaysWeatherDetails(city: weather.name,
                                                           minTemperature: weather.main.lowDescription,
                                                           currentTemperature: weather.main.currentTemp,
                                                           maxTemperature: weather.main.highDescription,
                                                           id: weather.weather.first?.id ?? 800,
                                                           dt: weather.dt,
                                                           lat: weather.coord.lat,
                                                           lon: weather.coord.lon)
                
                await MainActor.run {
                    print("Current weather: \(self.forecastData)")
                    
                    self.viewState = .loading
                }
            } catch let error as WeatherError {
                await MainActor.run {
                    self.showingError = true
                    self.errorDescription = error.errorDescription
                    
                    self.viewState = .error
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
                    
                    self.viewState = .error
                }
            }
        }
    }
    
    func getWeather(viewContext: NSManagedObjectContext) async {
        
        guard let locationManager = locationManager.location else {
            self.setupLocationDefaultError()
            setupCoreDataWeatherView(viewContext: viewContext)
            // failing that take the user to WeatherView but focus on searchBar?
            return
        }
        
        WeatherLocation.sharedInstance.long = locationManager.coordinate.longitude.description
        WeatherLocation.sharedInstance.lat = locationManager.coordinate.latitude.description
        
        await self.getCurrentWeather()
        await self.getWeatherForecast()
    }
    
    func setupCoreDataWeatherView(viewContext: NSManagedObjectContext) {
//        let managedObjectContext: NSManagedObjectContext
//        
        if !cityFetchedResults.isEmpty && !forecastFetchedResults.isEmpty {
            
            if let mainCity = cityFetchedResults.first {
                
                self.weatherDetails = TodaysWeatherDetails(city: mainCity.cityName,
                                                           minTemperature: mainCity.minTemp,
                                                           currentTemperature: mainCity.currentTemp,
                                                           maxTemperature: mainCity.maxTemp,
                                                           id: Int(mainCity.cityCondition),
                                                           dt: Int(mainCity.timeStamp),
                                                           lat: mainCity.lat,
                                                           lon: mainCity.lon)
                
                let predicate = NSPredicate(format: "cityName == %@", mainCity.cityName)
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "CityForecast")
                
                fetchRequest.predicate = predicate
                //fetchRequest.sortDescriptors = [] //optionally you can specify the order in which entities should ordered after fetch finishes
                
                do {
                    let forecastResult = try viewContext.execute(fetchRequest)
                    
                    if let forecastResultArray = Array(arrayLiteral: forecastResult) as? [CityForecast] {
                        for forecast in forecastResultArray {
                            self.forecastData.append(ForecastList(dt: Int(forecast.dayOfWeek),
                                                                  temp: Temp(temp: forecast.currentTemperature),
                                                                  weather: [Weather(id: Int(forecast.condition))]))
                        }
                    }
                } catch {
                    print("Whoops, error occurred fetching forecast: \(error.localizedDescription)")
                }
                
            } else {
                
            }
        }
        
        self.viewState = .weatherReceived
    }
    
    func setupLocationDefaultError() {
        self.errorCode = "Location not found.".uppercased()
        self.errorDescription = "Please review device's location settings and restart app.".uppercased()
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
