//
//  Weather.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import Foundation
import SwiftUICore

struct Weather: Codable {
    var id: Int
}

struct TodaysWeatherDetails {
    var city, minTemperature, currentTemperature, maxTemperature: String
    var id: Int
}

struct WeatherViewStyler {
    var backgroundImage, mainImage, currentCondition: String
    var backgroundColor: Color
}
