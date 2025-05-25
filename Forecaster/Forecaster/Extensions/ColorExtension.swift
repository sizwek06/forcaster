//
//  ColorExtension.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/25.
//

import SwiftUICore
import UIKit

extension Color {
    
    static var clearStackColor = Color(UIColor(named: "clearStackColor") ?? UIColor(Color.blue))
    static var rainyStackColor: Color { Color(UIColor(named: "rainyStackColor") ?? UIColor(Color.gray)) }
    static var cloudyStackColor: Color { Color(UIColor(named: "cloudyStackColor") ?? UIColor(Color.gray)) }
}
