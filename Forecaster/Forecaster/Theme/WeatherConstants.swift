//
//  WeatherConstants.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import SwiftUICore
import UIKit

struct WeatherConstants {
    
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

extension Color {
    
    static var clearStackColor = Color(UIColor(named: "clearStackColor") ?? UIColor(Color.blue))
    static var rainyStackColor: Color { Color(UIColor(named: "rainyStackColor") ?? UIColor(Color.gray)) }
    static var cloudyStackColor: Color { Color(UIColor(named: "cloudyStackColor") ?? UIColor(Color.gray)) }
}
