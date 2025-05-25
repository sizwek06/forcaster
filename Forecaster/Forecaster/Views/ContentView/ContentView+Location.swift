//
//  ContentView+Location.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import Foundation
import CoreLocation

extension ContentViewModel: CLLocationManagerDelegate {
    
    func requestLocation() {
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        self.viewState = .loading
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.errorDescription = "Error: \(error.localizedDescription)"
        self.showingError = true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.viewState = .loading
        case .notDetermined:
            self.viewState = .locationUnknown
        default:
            provideLocationErrorDetails()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.viewState = .loading
    }
    
    func provideLocationErrorDetails() {
        self.viewState = .error
        
        self.errorCode = "0000"
        self.errorDescription = "Location not found, please review device settings and restart app."
        self.showingError = true
    }
}
