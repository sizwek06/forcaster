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
//        guard let temp = temp else { return "" }
        return "\(Int(temp))º"
    }
    
    var highDescription: String {
//        guard let tempMax = tempMax else { return "" }
        return "\(Int(tempMax))ºC"
    }
    
    var lowDescription: String {
//        guard let tempMin = tempMin else { return "" }
        return "\(Int(tempMin))ºC"
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
