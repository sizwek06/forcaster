//
//  MapView.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Map(interactionModes: [.rotate, .zoom])
                }
                .searchable(text: $searchText)
                .navigationTitle(WeatherConstants.mapsNavtitle)
            }
            .background(.clear)
        }
    }
}

// MARK: Preview Section
#Preview {
    MapView()
}
