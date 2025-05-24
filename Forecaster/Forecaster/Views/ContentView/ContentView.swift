//
//  ContentView.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        VStack(alignment: .center) {
            getBody()
                .onAppear {
                    self.viewModel.requestLocation()
                    
                    if viewModel.viewState == .loading && !viewModel.showingError {
                        Task {
                            await getWeatherDetails()
                        }
                    }
                }
                .sheet(isPresented: self.$viewModel.showingError) {
                    ErrorView(isPresented: self.$viewModel.showingError, errorTitle: self.viewModel.errorCode,
                              errorDescription: self.viewModel.errorDescription)
                }
                .onDisappear {
                    self.viewModel.showingError = false
                }
                .onChange(of: viewModel.showingError) {
                    self.viewModel.requestLocation()
                    
                    Task {
                        await getWeatherDetails()
                    }
                }
        }
    }
    
    @ViewBuilder
    fileprivate func getBody() -> some View {
        
        switch viewModel.viewState {
            
        case .loading:
            LoadingView()
        case .weatherReceived:
            WeatherView(viewModel: self.setupWeatherWebservicesViewModel())
        case .locationUnknown:
            // create weather view via storedData
            WeatherView(viewModel: self.setupWeatherWebservicesViewModel())
        case .error:
            ErrorView(isPresented: self.$viewModel.showingError,
                      errorTitle: self.viewModel.errorCode,
                      errorDescription: self.viewModel.errorDescription)
        case .launch:
            LoadingView()
        }
    }
    
    func getWeatherDetails() async {
        self.viewModel.viewState = self.viewModel.checkLocationStatus()
        
        Task {
            await self.viewModel.getWeather(viewContext: viewContext)
        }
    }
    
    func setupWeatherWebservicesViewModel() -> WeatherViewModel {
        
        guard let weatherDetails = self.viewModel.weatherDetails,
              let dt = self.viewModel.dt else {
            
            return WeatherViewModel(weatherDetails: TodaysWeatherDetails(city: "Unknown City",
                                                                         minTemperature: "0",
                                                                         currentTemperature: "0",
                                                                         maxTemperature: "0",
                                                                         id: 800),
                                    weatherForcast: self.viewModel.createFiveDayForecast(),
                                    dt: Int(Date().timeIntervalSince1970))
            // TODO: Handle the above as forecastData.isEmpty and focus user onto search bar
        }
        
        return WeatherViewModel(weatherDetails: weatherDetails,
                                weatherForcast: self.viewModel.createFiveDayForecast(),
                                dt: dt)
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
