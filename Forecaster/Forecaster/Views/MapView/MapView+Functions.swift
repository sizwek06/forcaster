//
//  MapView+Functions.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/26.
//
import MapKit
import _MapKit_SwiftUI
import SwiftUICore
import GooglePlaces

extension MapView {
    
    func getUserPosition(selectedCity: TodaysWeatherDetails? = nil) -> MKCoordinateRegion {
        
        if let city = selectedCity {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:  city.lat,
                                                                  longitude:  city.lon),
                                   span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        } else {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:  WeatherLocation.sharedInstance.lat,
                                                                  longitude:  WeatherLocation.sharedInstance.lon),
                                   span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        }
    }
    
    func createLocationsArray(cityList: [FavouriteCity]) -> [MapLocation] {
        var cityArray: [MapLocation] = []
        
        cityArray.append(MapLocation(cityName: todayWeatherDetails.city, todayWeather: todayWeatherDetails,
                                     coord: CLLocationCoordinate2D(latitude: todayWeatherDetails.lat,
                                                                   longitude: todayWeatherDetails.lon)))
        
        for city in cityList {
            cityArray.append(MapLocation(cityName: city.cityName,
                                         todayWeather: TodaysWeatherDetails(city: city.cityName,
                                                                         minTemperature: city.minTemp,
                                                                         currentTemperature: city.currentTemp,
                                                                         maxTemperature: city.maxTemp,
                                                                         id: Int(city.cityCondition),
                                                                         dt: Int(city.timeStamp),
                                                                         lat: city.lat,
                                                                         lon: city.lon),
                                         coord: CLLocationCoordinate2D(latitude: city.lat,
                                                                       longitude: city.lon)))
        }
        
        return cityArray
    }
}

struct MarkerView: View {
    let place: MapLocation
    
    var body: some View {
        HStack {
            Image(systemName: place.condition)
                .foregroundColor(.black)
                .font(.title)
                .fontWeight(.bold)
            Text("\(place.cityName) \n \(place.todayWeather.currentTemperature)")
                .font(.caption)
        }
        .padding(.all, 5)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12.0))
        .shadow(radius: 8)
    }
}

struct MapLocation: Identifiable {
    let id = UUID()
    let cityName: String
    let todayWeather: TodaysWeatherDetails
    let coord: CLLocationCoordinate2D
                
    var condition: String {
        switch todayWeather.id {
        case 200...799:
            return "cloud.rain"
        case 800...899:
            return "cloud.sun"
        default:
            return "sun.max"
        }
    }
}
