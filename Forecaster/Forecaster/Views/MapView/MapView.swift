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
    @FocusState private var citySearchFocus: Bool
    @State var isFavePopoverPresented: Bool = false
    @State private var selectedCity: TodaysWeatherDetails? = nil
    
    @Environment(\.managedObjectContext) var viewContext
    
    var cityList: [FavouriteCity] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Map(interactionModes: [.rotate, .zoom])
                }
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button {
                            isFavePopoverPresented = true
                        } label: {
                            Image(systemName: "star.fill")
//                                .foregroundStyle(.black)
                        }
                    }
                }
                .popover(isPresented: $isFavePopoverPresented) {
                    
                    FavouritesListView(selection: $selectedCity,
                                       cityList: self.cityList)
                    
                    .presentationCompactAdaptation(.sheet)
                }
                .onChange(of: selectedCity) {
                    citySearchFocus = true
                    searchText = selectedCity?.city ?? ""
                }
                .searchable(text: $searchText, isPresented: $citySearchActive, prompt: "")
                .searchFocused($citySearchFocus)
                .navigationTitle(WeatherConstants.mapsNavtitle)
                .navigationBarTitleDisplayMode(.large)
            }
            .background(.clear)
        }
    }
}

// MARK: Preview Section
#Preview {
    let context = PersistenceController.preview.container.viewContext
    let cities = makeSampleCities(in: context)

    MapView(cityList: cities)
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
