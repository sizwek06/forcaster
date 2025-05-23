//
//  HTTPClient.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import Foundation

public protocol EndpointProvider {

    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var queryItems: [URLQueryItem]? { get }
}

extension EndpointProvider {

    var scheme: String {
        return "https"
    }

    var baseURL: String {
        return "api.openweathermap.org"
    }

    func asURLRequest() throws -> URLRequest {

        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = baseURL
        urlComponents.path = path
        
        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }
        
        print("The current url \(String(describing: urlComponents.url))")
        
        guard let url = urlComponents.url else {
            throw WeatherError(errorCode: 0, errorDescription: "URL error")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("URL request: \(urlRequest)")
        return urlRequest
    }
}

enum WeatherEndpoints: EndpointProvider {

    case getCurrent
    case getForecast
    
    var path: String {
        switch self {
        case .getCurrent:
            return "/data/2.5/weather"
        case .getForecast:
            return "/data/2.5/forecast"
            // MARK: - [Sizwe K]: forecast5 doesn't exist anymore - "cod": "404", "message": "Internal error"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getCurrent, .getForecast:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getCurrent, .getForecast:
            return [URLQueryItem(name: "lat",
                             value: "\(WeatherLocation.sharedInstance.lat)"),
                    URLQueryItem(name: "lon",
                                 value: "\(WeatherLocation.sharedInstance.long)"),
                    URLQueryItem(name: "units",
                                 value: "metric"),
                    URLQueryItem(name: "appid",
                                         value: WeatherConstants.apiKey as? String),
                    URLQueryItem(name: "cnt", value: "40")]
        }/// MARK: - [Sizwe K]: I looked at 3 hour intervals by 8 and by 5, landed on 40 as a safe bet
    }
}
