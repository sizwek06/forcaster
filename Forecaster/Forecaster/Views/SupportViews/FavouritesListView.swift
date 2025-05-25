//
//  FavouritesListView.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/24.
//

import SwiftUICore
import SwiftUI

struct FavouritesListView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var selection: TodaysWeatherDetails?
    
    var cityList: [FavouriteCity]
    
    var body: some View {
        PopoverContainer {
            VStack(alignment: .center) {
                Text(WeatherConstants.favouritesListViewTitle)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 15)
                    .padding(.bottom, 10)
                    .padding(.leading, 15)
                Divider()
                
                List {
                    Section(header:
                                Text(WeatherConstants.favouritesListSubtitle)
                                    .font(.title2)
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
                                                     dt: Int(city.timeStamp))
                                    
                                    selection = today
                                    dismiss()
                                }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                Spacer()
            }
        }
    }
}
