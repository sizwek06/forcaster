//
//  WeatherLocation.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import Foundation

public class WeatherLocation {
    
    var lat: Double = 0.0
    var lon: Double = 0.0
    var city: String = ""
    
    public static let sharedInstance = WeatherLocation()
    
    public init() {}
}
