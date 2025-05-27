//
//  MapView+Places.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/26.
//
import GooglePlaces

extension MapView {
    
    func setupPlaces(lat: Double, lon: Double) -> [GMSPlace] {
        
        // Array to hold the places in the response
        var placeResults: [GMSPlace] = []
        
        // Define the search area as a 500 meter diameter circle in San Francisco, CA.
        let circularLocationRestriction = GMSPlaceCircularLocationOption(CLLocationCoordinate2DMake(lat, lon), 500)
        
        // Specify the fields to return in the GMSPlace object for each place in the response.
        let placeProperties = [GMSPlaceProperty.name, GMSPlaceProperty.coordinate].map {$0.rawValue}
        
        // Create the GMSPlaceSearchNearbyRequest, specifying the search area and GMSPlace fields to return.
        var request = GMSPlaceSearchNearbyRequest(locationRestriction: circularLocationRestriction, placeProperties: placeProperties)
        let includedTypes = ["restaurant", "cafe"]
        request.includedTypes = includedTypes
        
        let callback: GMSPlaceSearchNearbyResultCallback = { results, error in
            
            if let err = error {
                print("The error: \(err)")
            } else {
                guard let results = results else {
                    return
                }
                
                placeResults = results
                print("The places: \(results)")
            }
        }

        GMSPlacesClient.shared().searchNearby(with: request, callback: callback)
        return placeResults
    }
}
