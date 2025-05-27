//
//  FavouritesListView.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/24.
//

import SwiftUICore
import SwiftUI
import CoreData

struct FavouritesListView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var selection: TodaysWeatherDetails?
    @Environment(\.managedObjectContext) var viewContext
    @State private var searchText = ""
    @FocusState private var citySearchFocus: Bool
    
    var cityList: [FavouriteCity]
    
    var searchResults: [FavouriteCity] {
        searchText.isEmpty ? cityList : cityList.filter { $0.cityName.contains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                
                PopoverContainer {
                    List {
                        Section(header:
                                    Text(WeatherConstants.mapsNavListSubtitle)
                            .font(.headline)
                            .fontWeight(.regular)
                        ) {
                            ForEach(searchResults) { city in
                                Text(city.cityName)
                                    .font(.title3)
                                    .onTapGesture {
                                        let today = TodaysWeatherDetails(city: city.cityName,
                                                                         minTemperature: city.minTemp,
                                                                         currentTemperature: city.currentTemp,
                                                                         maxTemperature: city.maxTemp,
                                                                         id: Int(city.cityCondition),
                                                                         dt: Int(city.timeStamp),
                                                                         lat: city.lat,
                                                                         lon: city.lon)
                                        
                                        selection = today
                                        dismiss()
                                    }
                            }
                            .onDelete(perform: deleteTask)
                        }
                        .listStyle(.insetGrouped)
                    }
                }
                .onAppear {
                    citySearchFocus = true
                }
            }
            .tint(.accentColor)
            .searchable(text: $searchText, prompt: WeatherConstants.mapsCitySearchPrompt)
            .searchFocused($citySearchFocus)
            .navigationTitle(WeatherConstants.appName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func deleteTask(at indexSet: IndexSet) {
        for index in indexSet {
            let city = cityList[index].cityName
            
            deleteExistingCity(favouriteCity: city)
            
            do {
                try viewContext.save()
                print("Weather saved!")
            } catch let error {
                print("Save failed: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteExistingCity(favouriteCity: String) {
        let req: NSFetchRequest<FavouriteCity> = FavouriteCity.fetchRequest()
        
        req.predicate = NSPredicate(format: "cityName == %@", favouriteCity)
        
        do {
            let cities = try viewContext.fetch(req)
            print("✅ Found \(cities.count) cities")
            
            for city in cities {
                deleteCity(city: city, viewContext: viewContext)
            }
        } catch {
            print("⛔️ Failed to fetch forecasts: \(error.localizedDescription)")
        }
    }
    
    func deleteCity(city: FavouriteCity, viewContext: NSManagedObjectContext) {
        viewContext.delete(city)
        
        do {
            try viewContext.save()
            print("✅ Delete done")
        } catch {
            print("⛔️ Error deleting")
        }
    }
}

// MARK: Preview Section
#Preview("FavouritesList") {
    @Previewable var selection = TodaysWeatherDetails(city: WeatherConstants.previewCity,
                                                      minTemperature: WeatherConstants.previewCityMinTempTitle,
                                                      currentTemperature: WeatherConstants.previewCityTempTitle,
                                                      maxTemperature: WeatherConstants.previewCityMaxTempTitle,
                                                      id: 0,
                                                      dt: 1748206800,
                                                      lat: 18.55,
                                                      lon: -33.82)
    
    let context = PersistenceController.preview.container.viewContext
    let cities = makeSampleCities(in: context)
    
    let view = FavouritesListView(selection: .constant(selection), cityList: cities)
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
