//
//  OpenWeather.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import Foundation

struct OpenWeather: Codable {
    var coord: Location?
    var weather: [Weather]?
    var base: String?
    var main: WeatherData?
    var visibility: Int?
    var dt: Int?
    var sys: Sys?
    var timezone, id: Int?
    var name: String?
    var cod: Int?
}


// MARK: - Sys
struct Sys: Codable {
    var type, id: Int?
    var country: String?
    var sunrise, sunset: Int?
}

struct Location: Codable {
    var lon, lat: Double?
}
