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
    
    @Published var todayWeatherDetails: TodaysWeatherDetails
    @Published var forecastData: [ForecastList] = []
    @Published var dt: Int
    
    var errorDescription: String?
    var errorCode: String?
    
    let apiClient: WeatherApiProtocol!
    
    init(apiClient: WeatherApiProtocol = WeatherApiClient(),
         weatherDetails: TodaysWeatherDetails,
         weatherForcast: [ForecastList],
         dt: Int) {
        
        self.apiClient = apiClient
        self.todayWeatherDetails = weatherDetails
        self.forecastData = weatherForcast
        self.dt = dt
    }
    
    func getFavouriteCities(fetchedResults: FetchedResults<FavouriteCity>) -> [FavouriteCity] {
        
        return Dictionary(grouping: fetchedResults, by: { $0.cityName})
            .compactMap { $0.value.first }
    }
    
    func returnFavCity(viewContext: NSManagedObjectContext) -> FavouriteCity {
        let favouriteCity = FavouriteCity(context: viewContext)
        
        favouriteCity.cityName = self.todayWeatherDetails.city
        favouriteCity.timeStamp = self.dt.convertToUnit16()
        
        favouriteCity.minTemp = self.todayWeatherDetails.minTemperature
        favouriteCity.maxTemp = self.todayWeatherDetails.maxTemperature
        favouriteCity.currentTemp = self.todayWeatherDetails.currentTemperature
         
        favouriteCity.itemIdentifier = UUID()
        
        return favouriteCity
    }
    
    func addToCoreData(viewContext: NSManagedObjectContext) {
        let weatherD = self.todayWeatherDetails
        
        for forecast in self.forecastData {
            let cityForecast = CityForecast(context: viewContext)
            
            cityForecast.dayOfWeek = self.dt.convertToUnit16()
            cityForecast.currentTemperature = forecast.temp.temp
            cityForecast.condition = Int16(forecast.weather[0].id)

            cityForecast.cityName = weatherD.city
            cityForecast.relationship = returnFavCity(viewContext: viewContext)
            
            cityForecast.timeStamp = self.dt.convertToUnit16()
            
            cityForecast.minTemp = weatherD.minTemperature
            cityForecast.maxTemp = weatherD.maxTemperature
            cityForecast.currentTemp = weatherD.currentTemperature
             
            cityForecast.itemIdentifier = UUID()
        }
        
        do {
            try viewContext.save()
            print("Weather saved!")
        } catch {
            print("Whoops, error occurred: \(error.localizedDescription)")
        }
    }
    
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
                                                               id: weather.weather.first?.id ?? 800)
                    // TODO: Properly Unwrap above values?
                    
                    print("Current weather: \(self.forecastData)")
                    self.dt = weather.dt
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
