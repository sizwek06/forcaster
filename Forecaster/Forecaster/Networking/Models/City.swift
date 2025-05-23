//
//  City.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import Foundation

struct City: Codable {
    var id: Int?
    var name: String?
    var coord: Location?
    var country: String?
    var population, timezone: Int?
}
