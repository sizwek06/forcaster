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
        return "\(Int(temp.temp))ºC"
    }
    
    var date: String {
        let dateValue = dt.dateFromInt
        return DateManager.day.stringFrom(date: Date()) == DateManager.day.stringFrom(date: dateValue) ? "Today" : DateManager.day.stringFrom(date: dateValue)
    }

    enum CodingKeys: String, CodingKey {
        case dt
        case weather
        case temp = "main"
    }
}

extension Int {
    var dateFromInt: Date {
        Date(timeIntervalSince1970: TimeInterval(integerLiteral: Int64(self)))
    }
}

struct Temp: Codable {
    var temp: Double
}
