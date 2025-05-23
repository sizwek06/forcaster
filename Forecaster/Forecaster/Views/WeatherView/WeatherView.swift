//
//  WeatherView.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import SwiftUICore
import SwiftUI

struct WeatherView: View {
    @ScaledMetric(relativeTo: .headline) var dynamicHeaderSize = 65
    @ScaledMetric(relativeTo: .headline) var dynamicSubheaderSize = 40
    @ScaledMetric(relativeTo: .title) var dynamicTitleSize = 29
    @ScaledMetric(relativeTo: .body) var dynamicTextSize = 15
    
    @ObservedObject var viewModel: WeatherViewModel
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            
            VStack(spacing: -10) {
                    // Background header Image
                    createCurrentWeatherView()
                    // Header of current
                    createCurrentForecastView()
                
            ScrollView {
                    createCurrentForecastTableView()
                    createTimeStampUpdate()
                }
                .background(setupViewTheme().backgroundColor)
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    HStack (spacing: 50) {
                        Button(action: {
                            // do something
                        }) {
                            VStack(spacing: 5) {
                                Image(systemName: "cloud.sun.fill")
                                Text("5-Day Forecast")
                                    .font(.subheadline)
                            }
                            .foregroundStyle(.white)
                        }
                        
                        Button(action: {
                            // do something
                        }) {
                            VStack(spacing: 5) {
                                Image(systemName: "star.fill")
                                Text("Faves")
                                    .font(.subheadline)
                            }
                            .foregroundStyle(.white)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            .background(setupViewTheme().backgroundColor)
        }
    }
    
    // MARK: - Views
    
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
        }
    }
    
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
    
    func createTimeStampUpdate() -> some View {
        HStack() {
            Text("Time updated: \(self.viewModel.dt)")
                .multilineTextAlignment(.trailing)
                .dynamicTypeSize(.small)
                .italic()
                .foregroundStyle(.white)
                .padding(.leading, 120)
        }
    }
    
    func createCurrentForecastView() -> some View {
        VStack(spacing: 5) {
            HStack(spacing: 5) {
                Spacer()
                currentText(degrees: self.viewModel.todayWeatherDetails.minTemperature,
                            text: "min")
                .padding(.leading, -15)
                currentText(degrees: self.viewModel.todayWeatherDetails.currentTemperature,
                            text: "Current")
                .padding(.leading, 65)
                currentText(degrees: self.viewModel.todayWeatherDetails.maxTemperature,
                            text: "max")
                .padding(.leading, 75)
            }
            .background(setupViewTheme().backgroundColor)
            .frame(width: WeatherConstants.returnDesiredWidth())
            
            Rectangle()
                .foregroundColor(.white)
                .frame(height: 1)
        }
    }
    
    
    func createCurrentForecastTableView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
            ForEach(self.viewModel.forecastData) { forecast in
                createForecastCell(day: forecast.date,
                                   condition: forecast.weather[0].id,
                                   degrees: forecast.temperature)
            }
        }
        .frame(width: WeatherConstants.returnDesiredWidth())
        .background(setupViewTheme().backgroundColor)
    }
    
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
                .padding(.leading, 65)
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
    
    // MARK: - View Styling
    
    func getForecastCellWeatherIcon(weatherId: Int) -> String {
        
        switch weatherId {
        case 200...799:
            return "rain"
        case 800...899:
            return "partlysunny"
        default:
            return "clear"
        }
    }
    
    func setupViewTheme() -> WeatherViewStyler {
        switch viewModel.todayWeatherDetails.id {
            case 200...799:
                return WeatherViewStyler(backgroundImage: "rainyStackColor",
                                         mainImage: "sea_rainy",
                                         currentCondition: "Rainy",
                                         backgroundColor: Color.rainyStackColor)
            case 800...899:
                return WeatherViewStyler(backgroundImage: "cloudyStackColor",
                                         mainImage: "sea_cloudy",
                                         currentCondition: "Cloudy",
                                         backgroundColor: Color.cloudyStackColor)
        default:
            return WeatherViewStyler(backgroundImage: "cloudyStackColor",
                                     mainImage: "sea_sunnypng",
                                     currentCondition: "Sunny",
                                     backgroundColor: Color.clearStackColor)
            }
        }
    }


#Preview {
    
    let viewModel = WeatherViewModel(weatherDetails: TodaysWeatherDetails(city: "Land of Oo",
                                                                           minTemperature: "15°",
                                                                          currentTemperature: "17°",
                                                                          maxTemperature: "25°",
                                                                          id: 100),
                                     weatherForcast: [ForecastList(dt: 1748120400, temp: Temp(temp: 18.63),
                                                                   weather: [Weather(id: 205)]),
                                                      ForecastList(dt: 1748206800, temp: Temp(temp: 15.49),
                                                                   weather: [Weather(id: 305)]),
                                                      ForecastList(dt: 1748293200, temp: Temp(temp: 13.28),
                                                                   weather: [Weather(id: 805)]),
                                                      ForecastList(dt: 1748379600, temp: Temp(temp: 15.56),
                                                                   weather: [Weather(id: 100)]),
                                                      ForecastList(dt: 1748390400, temp: Temp(temp: 15.13),
                                                                   weather: [Weather(id: 800)])], dt: "Tuesday, May 23"
                                    )
    
     WeatherView(viewModel: viewModel)
}
