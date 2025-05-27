//
//  PlacesListView.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/27.
//

import SwiftUICore
import SwiftUI
import GooglePlaces

struct PlacesListView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    var currentCityName: String
    var placesList: [CustomPlace]
    
    init(currentCity: String, placesList: [CustomPlace]) {
        self.currentCityName = currentCity
        self.placesList = placesList
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                PopoverContainer {
                    List {
                        ForEach(placesList) { place in
//                            PlacesListCell(place: place)
                            Text("\(place.place.name)")
                        }
                    }
                    .listStyle(.inset)
                    .padding(.bottom, 30)
                    .padding(.leading, 20)
                    .listRowInsets(.init(top: 20, leading: 0, bottom: 20, trailing: 0))
                    .listRowSeparator(.hidden)
                }
            }
            .navigationTitle(self.currentCityName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CustomPlace: Identifiable {
    let id = UUID()
    let place: GMSPlace
}
