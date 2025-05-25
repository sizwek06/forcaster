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
                    ErrorView(isPresented: self.$viewModel.showingError,
                              errorTitle: self.viewModel.errorCode,
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
            
        case .loading, .launch:
            LoadingView()
        case .weatherReceived:
            WeatherView(viewModel: self.setupWeatherWebservicesViewModel())
        case .locationUnknown:
            // create weather view via storedData
            // TODO: Check why the WeatherView flashes on clean install
            WeatherView(viewModel: self.setupWeatherWebservicesViewModel())
        case .error:
            ErrorView(isPresented: self.$viewModel.showingError,
                      errorTitle: self.viewModel.errorCode,
                      errorDescription: self.viewModel.errorDescription)
        }
    }
    
    func getWeatherDetails() async {
        self.viewModel.viewState = self.viewModel.checkLocationStatus()
        
        Task {
            await self.viewModel.getWeather(viewContext: viewContext)
        }
    }
    
    func setupWeatherWebservicesViewModel() -> WeatherViewModel {
        
        guard let weatherDetails = self.viewModel.weatherDetails else {
            
            return WeatherViewModel(weatherDetails: TodaysWeatherDetails(city: WeatherConstants.previewCity,
                                                                         minTemperature: WeatherConstants.previewCityMinTempTitle,
                                                                         currentTemperature: WeatherConstants.previewCityTempTitle,
                                                                         maxTemperature: WeatherConstants.previewCityMaxTempTitle,
                                                                         id: 0,
                                                                         dt: WeatherConstants.previewTimestamp),
                                    weatherForcast: WeatherConstants.previewForecast)
            // TODO: Handle the above as forecastData.isEmpty and focus user onto search bar
        }
        
        return WeatherViewModel(weatherDetails: weatherDetails,
                                weatherForcast: self.viewModel.createFiveDayForecast())
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
