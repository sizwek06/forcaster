//
//  WeatherApiMockHelper.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/27.
//

import Foundation

class WeatherApiMockHelper: WeatherApiProtocol {
    
    var invokeWeather = false
    var invokeForecast = false
    var invokeError = false
    
    private static func fetchJsonData(in file: String) throws -> Data {
        let path = Bundle(for: self).path(forResource: file, ofType: "json")
        return try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
    }
    
    static func fetchAndUnbox<T: Decodable>(in file: String) -> T {
        do {
            let data = try WeatherApiMockHelper.fetchJsonData(in: file)
            let details: T = try JSONDecoder().decode(T.self, from: data)
            return details
        } catch {
            fatalError("Cannot convert json file for testing")
        }
    }
    
    static func returnForecastResponse() -> Forecast {
        return WeatherApiMockHelper.fetchAndUnbox(in: "ForecastResponse")
    }
    
    static func returnWeatherResponse() -> OpenWeather {
        return WeatherApiMockHelper.fetchAndUnbox(in: "WeatherResponse")
    }
    
    static func returnWeatherApiErrorResponse() throws -> WeatherError {
        return WeatherApiMockHelper.fetchAndUnbox(in: "OwmApiError") as WeatherError
    }
    
    func asyncRequest<T>(endpoint: EndpointProvider, responseModel: T.Type) async throws -> T where T : Decodable {
        if invokeForecast {
            return WeatherApiMockHelper.returnForecastResponse() as! T
        } else if invokeWeather {
            return WeatherApiMockHelper.returnWeatherResponse() as! T
        } else if invokeError {
            throw WeatherError(statusCode: 401,
                               errorCode: 401,
                               errorDescription: "Unknown backend error".uppercased())
        } else {
            throw WeatherError(statusCode: 401,
                               errorCode: 401,
                               errorDescription: "Unknown backend error".uppercased())
        }
    }
    
    func reset() {
        invokeWeather = false
        invokeForecast = false
        invokeError = false
    }
}
