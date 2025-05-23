//
//  WeatherLocation.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import Foundation

public class WeatherLocation {
    
    var lat: String = ""
    var long: String = ""
    
    public static let sharedInstance = WeatherLocation()
    
    public init() {}
}
