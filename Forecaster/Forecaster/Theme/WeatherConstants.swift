//
//  WeatherConstants.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import SwiftUICore
import UIKit

struct WeatherConstants {
    
    // MARK: ToolBar
    static let weatherViewTitle = "Forecast"
    static let favouriteCitiesTitle = "Cities"
    static let mapsTitle = "Maps"
    
    // MARK: WeatherView
    static let currentMinTempTitle = "min"
    static let currentMaxTempTitle = "max"
    static let currentTempTitle = "Current"
    
    static let loaderText = "Fetching the weather!"
    static let addCityButtonTitle = "Add City".uppercased()
    
    // MARK: FavouritesList
    static let favouritesListViewTitle = "Select your City"
    static let favouritesListSubtitle = "✈️ Available Cities ✈️"
    static let favouritesListEmptyText = "  Tap to Search for new city! \n    "
    
    // MARK: MapView
    static let mapsNavtitle = "Find your city"
    
    // MARK: WeatherView Preview Defaults
    static let previewCity = "Land of Oo"
    static let previewCityMinTempTitle = "15°"
    static let previewCityMaxTempTitle = "18°"
    static let previewCityTempTitle = "25°"
    
    static let previewForecast = [ForecastList(dt: 1748120400, temp: Temp(temp: 18.63),
                                               weather: [Weather(id: 205)]),
                                  ForecastList(dt: 1748206800, temp: Temp(temp: 15.49),
                                               weather: [Weather(id: 305)]),
                                  ForecastList(dt: 1748293200, temp: Temp(temp: 13.28),
                                               weather: [Weather(id: 805)]),
                                  ForecastList(dt: 1748379600, temp: Temp(temp: 15.56),
                                               weather: [Weather(id: 100)]),
                                  ForecastList(dt: 1748390400, temp: Temp(temp: 15.13),
                                               weather: [Weather(id: 800)])]
    static let previewTimestamp = 1748055600
    
    // MARK: API Items
    static let apiKey = Bundle.main.infoDictionary?["API_KEY"] ?? ""
    static let generalUnknownError = "An Unknown Error has occurred"
    
    // MARK: Fonts
    static let sfPro = "SF-ProText"
    static let sfProRounded = "SFProRounded-Bold"
    static let sfProRegular = "SF-ProText-Regular"
    static let sfProBold = "SF-ProText-Semibold"
    
    static func returnDesiredWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}

extension Bundle {
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
