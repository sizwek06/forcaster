//
//  MapView+Functions.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/26.
//
import MapKit
import _MapKit_SwiftUI

extension MapView {
    
    func getUserPosition(selectedCity: TodaysWeatherDetails? = nil) -> MapCameraPosition {
        
        if let city = selectedCity {
            return MapCameraPosition.region(
                MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:  city.lat,
                                                                  longitude:  city.lon),
                                   span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
        } else {
            return MapCameraPosition.region(
                MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:  WeatherLocation.sharedInstance.lat,
                                                                  longitude:  WeatherLocation.sharedInstance.lon),
                                   span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
        }
    }
}
