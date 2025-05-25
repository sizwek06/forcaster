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
        HStack (spacing: 50) {
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
            
            Button(action: {
                self.isMapShown = false
                self.isFavePopoverPresented = true
                self.isWeatherShowing = false
            }) {
                VStack(spacing: 5) {
                    Image(systemName: isFavePopoverPresented ? "star.fill" : "star")
                    Text(WeatherConstants.favouriteCitiesTitle)
                        .font(.subheadline)
                }
                .foregroundStyle(.white)
            }
            
            Button(action: {
                self.isMapShown = true
                self.isFavePopoverPresented = false
                self.isWeatherShowing = false
            }) {
                VStack(spacing: 5) {
                    Image(systemName: isMapShown ? "globe.europe.africa.fill" : "globe.europe.africa")
                    Text(WeatherConstants.favouriteCitiesTitle)
                        .font(.subheadline)
                }
                .foregroundStyle(.white)
            }
        }
    }
}
