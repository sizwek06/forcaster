//
//  PlacesListCell.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/27.
//

import SwiftUICore
import GooglePlaces

struct PlacesListCell: View {
    let place: CustomPlace
    
    var body: some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .foregroundColor(.black)
                .font(.title)
                .fontWeight(.bold)
            Text("\(place.place.name ?? "Places Name") \n \(place.place.rating)/5 (\(place.place.userRatingsTotal) \n \(place.place.priceLevel)")
                .font(.caption)
        }
        .padding(.all, 5)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20.0))
        .shadow(radius: 8)
    }
}
