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
    // condition id
}

struct TodaysWeatherDetails: Equatable {
    var city, minTemperature, currentTemperature, maxTemperature: String
    var id, dt: Int
    // view id
}

struct WeatherViewStyler {
    var backgroundImage, mainImage, currentCondition: String
    var backgroundColor: Color
}
