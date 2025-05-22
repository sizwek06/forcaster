//
//  WeatherConstants.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import SwiftUICore
import UIKit

struct WeatherConstants {
    
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
    
    static var appearanceColor: Color { Color(UIColor(named: "AppearanceColor") ?? UIColor(Color.black)) }
    static var generalBackground: Color { Color(UIColor(named: "GeneralBackround") ?? UIColor(Color.white)) }
    static var graytextColor: Color { Color(UIColor(named: "GreyText") ?? UIColor(Color.white)) }
    static var currentStackColor: Color { Color(UIColor(named: "currentStackColor") ?? UIColor(Color.white)) }
    // TODO: Add default color to currentStackColor
}
