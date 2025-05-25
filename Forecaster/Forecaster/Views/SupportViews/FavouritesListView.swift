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
    
    var cityList: [FavouriteCity]
    
    var body: some View {
        PopoverContainer {
            VStack(alignment: .center) {
                if cityList.isEmpty {
                    Text(WeatherConstants.favouritesListEmptyText)
                        .font(.custom(WeatherConstants.sfProRounded,
                                      size: 17,
                                      relativeTo: .headline))
                        .padding(.top, 15)
                        .padding(.bottom, 10)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        .onTapGesture {
                            selection = nil
                            dismiss()
                        }
                } else {
                    Text(WeatherConstants.favouritesListViewTitle)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 15)
                        .padding(.bottom, 10)
                        .padding(.leading, 10)
                    Divider()
                    
                    List {
                        Section(header:
                                    Text(WeatherConstants.favouritesListSubtitle)
                            .font(.headline)
                            .fontWeight(.semibold)
                        ) {
                            ForEach(cityList) { city in
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
            }
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
