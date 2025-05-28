//
//  MapView.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/25.
//

import SwiftUI
import MapKit
import CoreData

struct MapView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    @State private var citySearchActive = false
    @State private var userSearching = false
    @FocusState private var citySearchFocus: Bool
    @State var isFavePopoverPresented: Bool = false
    @State private var selectedCity: TodaysWeatherDetails? = nil
    
    @State private var position: MKCoordinateRegion
    var todayWeatherDetails: TodaysWeatherDetails
    
    @Environment(\.managedObjectContext) var viewContext
    
    var cityList: [FavouriteCity] = []
    
    var searchResults: [FavouriteCity] {
        searchText.isEmpty ? cityList : cityList.filter{ $0.cityName.contains(searchText)}
    }
    
    init(todayWeatherDetails: TodaysWeatherDetails, cityList: [FavouriteCity]) {
            self.todayWeatherDetails = todayWeatherDetails
            self.cityList = cityList
            
            self.position = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.todayWeatherDetails.lat,
                                                                              longitude:  self.todayWeatherDetails.lon),
                                               span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Map(coordinateRegion: $position,
                        annotationItems: createLocationsArray(cityList: self.cityList)) { place in
                        MapAnnotation(coordinate: place.coord) {
                            MarkerView(place: place)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isFavePopoverPresented = true
                        } label: {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.black)
                        }
                    }
                }
                .popover(isPresented: $isFavePopoverPresented) {
                    
                    FavouritesListView(selection: $selectedCity,
                                       cityList: self.cityList)
                    
                    .presentationCompactAdaptation(.sheet)
                    .presentationDetents([.height(375)])
                }
                .onChange(of: selectedCity) {
                    searchText = selectedCity?.city ?? ""
                    
                    position = getUserPosition(selectedCity: selectedCity)
                }
                .onAppear {
                    position = getUserPosition()
                }
            }
            .navigationTitle(WeatherConstants.mapsNavtitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .background(.clear)
        }
    }
}

// MARK: Preview Section
#Preview {
    let context = PersistenceController.preview.container.viewContext
    let cities = makeSampleCities(in: context)
    
    let today = TodaysWeatherDetails(city: WeatherConstants.previewCity,
                                         minTemperature: WeatherConstants.previewCityMinTempTitle,
                                         currentTemperature: WeatherConstants.previewCityTempTitle,
                                         maxTemperature: WeatherConstants.previewCityMaxTempTitle,
                                         id: 0,
                                         dt: 1748206800,
                                         lat: 18.55,
                                         lon: -33.82)
    
    MapView(todayWeatherDetails: today, cityList: cities)
            .environment(\.managedObjectContext, context)
}

private func makeSampleCities(in context: NSManagedObjectContext) -> [FavouriteCity] {
    let city1 = FavouriteCity(context: context)
    city1.cityName = "London"
    city1.currentTemp = "15"
    city1.itemIdentifier = UUID()
    city1.maxTemp = "18"
    city1.minTemp = "10"
    city1.timeStamp = Int32(Date().timeIntervalSince1970)
    city1.cityCondition = 801
    city1.lat = 51.5074
    city1.lon = -0.1278
    city1.forecast = nil

    let city2 = FavouriteCity(context: context)
    city2.cityName = "New York"
    city2.currentTemp = "17"
    city2.itemIdentifier = UUID()
    city2.maxTemp = "22"
    city2.minTemp = "12"
    city2.timeStamp = Int32(Date().timeIntervalSince1970)
    city2.cityCondition = 500 
    city2.lat = 40.7128
    city2.lon = -74.0060
    city2.forecast = nil

    return [city1, city2]
}
