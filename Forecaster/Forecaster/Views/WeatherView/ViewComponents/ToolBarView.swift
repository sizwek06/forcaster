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
                self.isFavePopoverPresented = false
                self.isWeatherShowing = !self.isFavePopoverPresented
            }) {
                VStack(spacing: 5) {
                    Image(systemName: getToolBarWeatherIcon())
                    Text(WeatherConstants.weatherViewTitle)
                        .font(.subheadline)
                }
                .foregroundStyle(.white)
            }
            
            Button(action: {
                self.isFavePopoverPresented = true
                self.isWeatherShowing = !self.isFavePopoverPresented
            }) {
                VStack(spacing: 5) {
                    Image(systemName: isFavePopoverPresented ? "star.fill" : "star")
                    Text(WeatherConstants.favouriteCitiesTitle)
                        .font(.subheadline)
                }
                .foregroundStyle(.white)
            }
        }
    }
}
