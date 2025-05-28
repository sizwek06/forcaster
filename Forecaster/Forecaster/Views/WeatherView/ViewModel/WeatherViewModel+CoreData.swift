//
//  WeatherViewModel+CoreData.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/27.
//

import CoreData
import SwiftUI

extension WeatherViewModel {
    
    func setupCoreDataWeatherView(cityFetchedResults: FetchedResults<FavouriteCity>, viewContext: NSManagedObjectContext) {
            
        if let mainCity = cityFetchedResults.first {
            
            self.todayWeatherDetails = TodaysWeatherDetails(city: mainCity.cityName,
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
        }
    }
    
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
        
        if let todayWeatherDetails = self.todayWeatherDetails {
            
            favouriteCity.cityName = todayWeatherDetails.city
            favouriteCity.timeStamp = Int32(todayWeatherDetails.dt)
            
            favouriteCity.minTemp = todayWeatherDetails.minTemperature
            favouriteCity.maxTemp = todayWeatherDetails.maxTemperature
            favouriteCity.currentTemp = todayWeatherDetails.currentTemperature
            
            favouriteCity.cityCondition = Int16(todayWeatherDetails.id)
            favouriteCity.lat = todayWeatherDetails.lat
            favouriteCity.lon = todayWeatherDetails.lon
            
            print("VM cityCondition \(todayWeatherDetails.id)")
            print("VM Int16 cityCondition \(Int16(todayWeatherDetails.id))")
            favouriteCity.itemIdentifier = UUID()
        }
        return favouriteCity
    }
    
    func addToCoreData(viewContext: NSManagedObjectContext) {
        if let todayWeatherDetails = self.todayWeatherDetails {
            
            deleteExistingCity(favouriteCity: todayWeatherDetails.city,
                               viewContext: viewContext)
        }
        
        if let todayWeatherDetails = self.todayWeatherDetails {
            
            for forecast in self.forecastData {
                let cityForecast = CityForecast(context: viewContext)
                
                cityForecast.dayOfWeek = Int32(forecast.dt)
                cityForecast.currentTemperature = forecast.temp.temp
                cityForecast.condition = Int16(forecast.weather[0].id)
                
                cityForecast.cityName = todayWeatherDetails.city
                cityForecast.relationship = returnFavCity(viewContext: viewContext)
                
                cityForecast.timeStamp = Int32(todayWeatherDetails.dt)
                
                cityForecast.minTemp = todayWeatherDetails.minTemperature
                cityForecast.maxTemp = todayWeatherDetails.maxTemperature
                cityForecast.currentTemp = todayWeatherDetails.currentTemperature
                
                cityForecast.itemIdentifier = UUID()
            }
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
}
