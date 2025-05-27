//
//  ForecasterAppDelegate.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/26.
//

import SwiftUI
import GooglePlaces

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey("AIzaSyBUg50CQb-AYuvxarDnaRvsh9W9lXc3n6Y")
        return true
    }
}
