//
//  WeatherError.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

struct WeatherError: Error, Decodable {

    var statusCode: Int!
    var errorCode: Int
    var errorDescription: String
    
    init(statusCode: Int = 0, errorCode: Int, errorDescription: String) {
        self.statusCode = statusCode
        self.errorCode = errorCode
        self.errorDescription = errorDescription
    }
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "cod"
        case errorDescription = "message"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        errorCode = try container.decode(Int.self, forKey: .errorCode)
        errorDescription = try container.decode(String.self, forKey: .errorDescription).uppercased()
    }
}
