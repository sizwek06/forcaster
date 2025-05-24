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
            
        case .loading, .locationUnknown:
            LoadingView()
        case .weatherReceived:
            WeatherView(viewModel: self.setupWeatherViewModel())
        }
    }
    
    func getWeatherDetails() async {
        self.viewModel.viewState = self.viewModel.checkLocationStatus()
        
        Task {
            await self.viewModel.getWeather()
        }
    }
    
    func setupWeatherViewModel() -> WeatherViewModel {
        
        guard let weatherDetails = self.viewModel.weatherDetails,
        let dt = self.viewModel.dt else {
            
            return WeatherViewModel(weatherDetails: TodaysWeatherDetails(city: "Unknown City",
                                                                         minTemperature: "0",
                                                                         currentTemperature: "0",
                                                                         maxTemperature: "0",
                                                                         id: 800),
                                    weatherForcast: self.viewModel.createFiveDayForecast(),
                                    dt: "Some date, sorry")
        }
        
        return WeatherViewModel(weatherDetails: weatherDetails,
                                weatherForcast: self.viewModel.createFiveDayForecast(),
                                dt: dt)
        }
}

#Preview {
    ContentView(viewModel: ContentViewModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
