//
//  ForecastList.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import Foundation

struct ForecastList: Codable, Identifiable {
    
    let id = UUID()
    var dt: Int
    var temp: Temp
    var weather: [Weather]
    
    var temperature: String {
        return "\(Int(temp.temp))º"
    }
   
    enum CodingKeys: String, CodingKey {
        case dt
        case weather
        case temp = "main"
    }
}

struct Temp: Codable {
    var temp: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
    }
}
