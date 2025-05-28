//
//  ToolBarView.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/25.
//

import SwiftUICore
import SwiftUI

extension WeatherView {
    
    @ViewBuilder
    func createToolBar() -> some View {
        HStack {
            Button(action: {
                self.isMapShown = false
                self.isFavePopoverPresented = false
                self.isWeatherShowing = true
            }) {
                VStack(spacing: 5) {
                    Image(systemName: getToolBarWeatherIcon())
                    Text(WeatherConstants.weatherViewTitle)
                        .font(.subheadline)
                }
                .foregroundStyle(.white)
            }
            
            Spacer()
            Button(action: {
                self.isMapShown = false
                self.isFavePopoverPresented = true
                self.isWeatherShowing = false
            }) {
                VStack(spacing: 5) {
                    Image(systemName: self.cityFetchedResults.isEmpty ? "star.slash" : (isFavePopoverPresented ? "star.fill" : "star"))
                    Text(WeatherConstants.favouriteCitiesTitle)
                        .font(.subheadline)
                }
                .foregroundStyle(.white)
            }
            .disabled(self.cityFetchedResults.isEmpty)
            Spacer()
            
            Button(action: {
                self.isMapShown = true
                self.isFavePopoverPresented = false
                self.isWeatherShowing = false
            }) {
                VStack(spacing: 5) {
                    Image(systemName: WeatherLocation.sharedInstance.lon == 0.0 ? "circle.badge.questionmark.fill" : (isMapShown ? "globe.europe.africa.fill" : "globe.europe.africa"))
                    Text(WeatherConstants.mapsTitle)
                        .font(.subheadline)
                }
                .disabled(WeatherLocation.sharedInstance.lon == 0.0)
                .foregroundStyle(.white)
            }
            // Stop user from going to mapView while online
        }
    }
}
