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
                Text("Select your City")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .padding(.leading, 15)
                Divider()
                
                List {
                    Section(header: Text("✈️ Available Cities ✈️")) {
                        
                        ForEach(cityList) { city in
                            Text(city.cityName)
                                .font(.title3)
                                .onTapGesture {
                                    let today = TodaysWeatherDetails(city: city.cityName,
                                                     minTemperature: city.minTemp,
                                                     currentTemperature: city.currentTemp,
                                                     maxTemperature: city.maxTemp,
                                                     id: Int(city.cityCondition))
                                    
                                    print("Tap Gesture worked: \(today)")
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
