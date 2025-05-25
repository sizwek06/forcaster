//
//  WeatherData.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import Foundation

struct WeatherData: Codable {
    var temp, feelsLike, tempMin, tempMax: Double
    var pressure, humidity, seaLevel, grndLevel: Int
    
    var currentTemp: String {
        return "\(Int(temp))º"
    }
    
    var highDescription: String {
        return "\(Int(tempMax))º"
    }
    
    var lowDescription: String {
        return "\(Int(tempMin))º"
    }

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}
