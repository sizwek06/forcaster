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
    
    var errorDescription: String?
    var errorCode: String?
    
    let apiClient: WeatherApiProtocol!
    
    init(apiClient: WeatherApiProtocol = WeatherApiClient(),
         weatherDetails: TodaysWeatherDetails,
         weatherForcast: [ForecastList]) {
        
        self.apiClient = apiClient
        self.todayWeatherDetails = weatherDetails
        self.forecastData = weatherForcast
    }
    
    // MARK: - CoreData Functionality
    func deleteExistingCity(favouriteCity: String, viewContext: NSManagedObjectContext) {
        let req: NSFetchRequest<FavouriteCity> = FavouriteCity.fetchRequest()
        
        req.predicate = NSPredicate(format: "cityName == %@", favouriteCity)
        
        do {
            let cities = try viewContext.fetch(req)
            print("✅ Found \(cities.count) cities")
            
            for city in cities {
                deleteCity(city: city, viewContext: viewContext)
            }
        } catch {
            print("⛔️ Failed to fetch forecasts: \(error.localizedDescription)")
        }
    }
    
    func getFavCityForecast(favouriteCity: String, viewContext: NSManagedObjectContext) {
       
        let req: NSFetchRequest<CityForecast> = CityForecast.fetchRequest()
        
        req.predicate = NSPredicate(format: "cityName == %@", favouriteCity)
        
        do {
            let forecasts = try viewContext.fetch(req)
            print("✅ Found \(forecasts.count) forecasts")
            
            self.forecastData.removeAll()
            
            for forecast in forecasts {
                self.forecastData.append(ForecastList(dt: Int(forecast.dayOfWeek),
                                                      temp: Temp(temp: forecast.currentTemperature),
                                                      weather: [Weather(id: Int(forecast.condition))]))
            }
        } catch {
            print("⛔️ Failed to fetch forecasts: \(error.localizedDescription)")
        }
    }
    
    func getFavouriteCities(fetchedResults: FetchedResults<FavouriteCity>) -> [FavouriteCity] {
        
        return Dictionary(grouping: fetchedResults, by: { $0.cityName})
            .compactMap { $0.value.first }
    }
    
    func returnFavCity(viewContext: NSManagedObjectContext) -> FavouriteCity {
        let favouriteCity = FavouriteCity(context: viewContext)
        
        favouriteCity.cityName = self.todayWeatherDetails.city
        favouriteCity.timeStamp = Int32(self.todayWeatherDetails.dt)
        
        favouriteCity.minTemp = self.todayWeatherDetails.minTemperature
        favouriteCity.maxTemp = self.todayWeatherDetails.maxTemperature
        favouriteCity.currentTemp = self.todayWeatherDetails.currentTemperature
        
        favouriteCity.cityCondition = Int16(self.todayWeatherDetails.id)
        favouriteCity.lat = self.todayWeatherDetails.lat
        favouriteCity.lon = self.todayWeatherDetails.lon
        
        print("VM cityCondition \(self.todayWeatherDetails.id)")
        print("VM Int16 cityCondition \(Int16(self.todayWeatherDetails.id))")
        print("entity cityCondition \(favouriteCity.cityCondition)")
        favouriteCity.itemIdentifier = UUID()
        
        return favouriteCity
    }
    
    func addToCoreData(viewContext: NSManagedObjectContext) {
        
        deleteExistingCity(favouriteCity: self.todayWeatherDetails.city,
                           viewContext: viewContext)
        
        let weatherD = self.todayWeatherDetails
        
        for forecast in self.forecastData {
            let cityForecast = CityForecast(context: viewContext)
            
            cityForecast.dayOfWeek = Int32(forecast.dt)
            cityForecast.currentTemperature = forecast.temp.temp
            cityForecast.condition = Int16(forecast.weather[0].id)

            cityForecast.cityName = weatherD.city
            cityForecast.relationship = returnFavCity(viewContext: viewContext)
            
            cityForecast.timeStamp = Int32(self.todayWeatherDetails.dt)
            
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
    
    func deleteCity(city: FavouriteCity, viewContext: NSManagedObjectContext) {
        viewContext.delete(city)
        
        do {
            try viewContext.save()
            print("✅ Delete done")
        } catch {
            print("⛔️ Error deleting")
        }
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
