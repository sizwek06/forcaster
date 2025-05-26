//
//  WeatherViewComponents.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/25.
//

import SwiftUICore
import UIKit
import SwiftUI

extension WeatherView {
    
    // MARK: - Current Weather: View
    @ViewBuilder
    func createCurrentWeatherView() -> some View {
        ZStack {
            Image(setupViewTheme().mainImage)
                .resizable()
                .frame(height: UIScreen.main.bounds.width - 20 / 5)
                .padding(.leading, -1) // To remove the Orange line next to shoreline (sunny.png)
                .scaledToFill()
            VStack {
                Text(self.viewModel.todayWeatherDetails.currentTemperature)
                    .font(.custom(WeatherConstants.sfProBold,
                                  size: dynamicHeaderSize))
                    .foregroundColor(.white)
                Text(setupViewTheme().currentCondition.uppercased())
                    .font(.custom(WeatherConstants.sfProBold,
                                  size: dynamicSubheaderSize))
                    .foregroundColor(.white)
            }
            
            Image(systemName: "arrow.clockwise.circle")
                .resizable()
                .frame(width: 35, height: 35)
                .padding(.leading, 290)
                .padding(.bottom, 300)
                .foregroundStyle(.white)
            // TODO: Use this to refresh weather info from API using q=cityName
        }
    }
    
    @ViewBuilder
    func currentText(degrees: String, text: String) -> some View {
        VStack(alignment: .center) {
            Text(degrees)
                .font(.custom(WeatherConstants.sfProRegular,
                              size: dynamicTextSize))
                .foregroundColor(.white)
            Text(text)
                .font(.custom(WeatherConstants.sfProRegular,
                              size: dynamicTextSize))
                .foregroundColor(.white)
        }
        .padding(.bottom, 10)
        .padding(.top, 5)
        .frame(minWidth: 75, alignment: .leading)
    }
    
    @ViewBuilder
    func createCurrentForecastView() -> some View {
        VStack(spacing: 5) {
            HStack(spacing: 5) {
                Spacer()
                currentText(degrees: self.viewModel.todayWeatherDetails.minTemperature,
                            text: WeatherConstants.currentMinTempTitle)
                .padding(.leading, -15)
                currentText(degrees: self.viewModel.todayWeatherDetails.currentTemperature,
                            text: WeatherConstants.currentTempTitle)
                .padding(.leading, 65)
                currentText(degrees: self.viewModel.todayWeatherDetails.maxTemperature,
                            text: WeatherConstants.currentMaxTempTitle)
                .padding(.leading, 70)
            }
            .background(setupViewTheme().backgroundColor)
            .frame(width: WeatherConstants.returnDesiredWidth())
            
            Rectangle()
                .foregroundColor(.white)
                .frame(height: 1)
        }
    }
    
    // MARK: - Forecast Section: Table
    @ViewBuilder
    func createForecastCell(day: String, condition: Int, degrees: String) -> some View {
        HStack {
            Text(day)
                .multilineTextAlignment(.leading)
                .font(.custom(WeatherConstants.sfProRegular,
                              size: dynamicTextSize))
                .foregroundColor(.white)
                .lineLimit(1)
                .frame(minWidth: 100, alignment: .leading)
            Image(self.getForecastCellWeatherIcon(weatherId: condition))
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .padding(.leading, 55)
            Text(degrees)
                .font(.custom(WeatherConstants.sfProRegular,
                              size: dynamicTextSize))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .padding(.trailing, 10)
                .padding(.leading, 100)
        }
        .background(setupViewTheme().backgroundColor)
        .padding(.bottom, 15)
    }
    
    @ViewBuilder
    func createCurrentForecastTableView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
            ForEach(self.viewModel.forecastData) { forecast in
                createForecastCell(day: forecast.dt.dayOfWeekString,
                                   condition: forecast.weather[0].id,
                                   degrees: forecast.temperature)
            }
        }
        .frame(width: WeatherConstants.returnDesiredWidth())
        .background(setupViewTheme().backgroundColor)
    }
    
    // MARK: - Current TimeStamp
    @ViewBuilder
    func createTimeStampUpdate() -> some View {
        HStack() {
            Text("'\(self.viewModel.todayWeatherDetails.city)' updated: \(self.viewModel.todayWeatherDetails.dt.updatedWhenString)")
                .multilineTextAlignment(.trailing)
                .dynamicTypeSize(.small)
                .italic()
                .foregroundStyle(.white)
                .padding(.leading, 100)
        }
        .padding(.trailing, 35)
    }
    
    // MARK: - Add Weather Button
    @ViewBuilder
    func createAddButton() -> some View {
        Button(action: {
            self.viewModel.addToCoreData(viewContext: viewContext)
            self.isFavePopoverPresented = true
        }) {
            Text(WeatherConstants.addCityButtonTitle)
                .frame(maxWidth: 250)
                .frame(height: 50)
                .foregroundColor(.white)
                .background(.orange)
                .cornerRadius(10)
        }
        .shadow(color: .red,
                radius: 21, y: 9)
    }
}
