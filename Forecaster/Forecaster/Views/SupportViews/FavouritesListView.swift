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
    @Binding var selection: FavouriteCity?
    
    var cityList: [FavouriteCity]
    
    var body: some View {
        PopoverContainer {
            VStack(alignment: .leading) {
                Text("Select your City")
                    .font(.title)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .padding(.leading, 15)
                Divider()
                
                List {
                    Section(header: Text("Available Cities")) {
                        
                        ForEach(cityList) { city in
                            Text(city.cityName)
                        }
                    }
                }
                .listStyle(.plain)
                Spacer()
            }
        }
    }
}
