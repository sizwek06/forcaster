//
//  MapView.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/25.
//

import SwiftUI
import MapKit
import CoreData
import GooglePlaces

struct MapView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    @State private var citySearchActive = false
    @State private var userSearching = false
    @FocusState private var citySearchFocus: Bool
    @State var activePopover: ActivePopover?
    
    @State private var selectedCity: TodaysWeatherDetails? = nil
    var todayWeatherDetails: TodaysWeatherDetails
    
    @State private var position: MKCoordinateRegion
    @Environment(\.managedObjectContext) var viewContext
    
    var cityArray: [MapLocation] = []
    
    var cityList: [FavouriteCity] = []
    @State var places: [CustomPlace] = []
    
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
                            MarkerView(place: place, places: places)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            activePopover = .favourites
                        } label: {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.black)
                        }
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            // TODO: onTapGesture go to current location
                        } label: {
                            Image(systemName: "mappin")
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
            .popover(item: $activePopover, content: { popover in
                switch popover {
                case .favourites:
                    FavouritesListView(selection: $selectedCity,
                                       cityList: self.cityList)
                    .presentationCompactAdaptation(.sheet)
                    .presentationDetents([.height(375)])
                case .places:
                    PlacesListView(currentCity: selectedCity?.city ?? "Inknown City",
                                   placesList: places)
                    .presentationCompactAdaptation(.sheet)
                    .presentationDetents([.height(375)])
                }
            })
            .onChange(of: selectedCity) {
                if let userCity = selectedCity {
                    
                    setupPlaces(lat: userCity.lat, lon: userCity.lon)
                    
                    searchText = userCity.city
                    activePopover = .places
                } else {
                }
            }
            .navigationTitle(WeatherConstants.mapsNavtitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
        .background(.clear)
    }
}

enum ActivePopover: Identifiable {
    case favourites
    case places

    var id: String {
        switch self {
        case .favourites: return "favourites"
        case .places: return "places"
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
    let cities: [(name: String, lat: Double, lon: Double, temp: String, condition: Int16)] = [
        ("Durban", -29.8587, 31.0218, "24", 800),
        ("Rome", 41.9028, 12.4964, "21", 801),
        ("Nice", 43.7102, 7.2620, "22", 802),
        ("Tokyo", 35.6895, 139.6917, "19", 803),
        ("Toronto", 43.6510, -79.3470, "16", 804),
        ("Cairo", 30.0444, 31.2357, "28", 800)
    ]
    
    return cities.map { city in
        let fav = FavouriteCity(context: context)
        fav.cityName = city.name
        fav.currentTemp = city.temp
        fav.itemIdentifier = UUID()
        fav.maxTemp = String(Int(city.temp)! + 3)
        fav.minTemp = String(Int(city.temp)! - 3)
        fav.timeStamp = Int32(Date().timeIntervalSince1970)
        fav.cityCondition = city.condition
        fav.lat = city.lat
        fav.lon = city.lon
        fav.forecast = nil
        return fav
    }
}
