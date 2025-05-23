//
//  Forecast.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import Foundation

struct Forecast: Codable {
    var city: City
    var cod: String
    var message: Double
    var cnt: Int
    var list: [ForecastList]
}

