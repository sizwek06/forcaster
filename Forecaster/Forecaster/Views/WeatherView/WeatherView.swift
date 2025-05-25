//
//  WeatherView.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import SwiftUICore
import SwiftUI
import CoreData

struct WeatherView: View {
    @ScaledMetric(relativeTo: .headline) var dynamicHeaderSize = 65
    @ScaledMetric(relativeTo: .headline) var dynamicSubheaderSize = 40
    @ScaledMetric(relativeTo: .title) var dynamicTitleSize = 29
    @ScaledMetric(relativeTo: .body) var dynamicTextSize = 15
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) private var cityFetchedResults: FetchedResults<FavouriteCity>
    @FetchRequest(sortDescriptors: []) private var forecastFetchedResults: FetchedResults<CityForecast>
    
    @ObservedObject var viewModel: WeatherViewModel
    
    @State var isWeatherShowing = true
    @State var isShowingSaveButton = false
    @State var currentWeather = "clear"
    
    @State private var isRotating = 0.0
    @State private var citySearchActive = false
    @FocusState private var citySearchFocus: Bool
    @State private var cityText = ""
    
    @State var isFavePopoverPresented: Bool = false
    @State private var selectedCity: TodaysWeatherDetails? = nil
    @State var cityListHeight: CGFloat = 0
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: -10) {
                
                createCurrentWeatherView()
                createCurrentForecastView()
                
                ScrollView {
                    createCurrentForecastTableView()
                    createTimeStampUpdate()
                    if isShowingSaveButton { createAddButton() }
                    // TODO: Update upon new city request
                }
                .scrollContentBackground(.hidden)
                .background(setupViewTheme().backgroundColor)
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    createToolBar()
                    .popover(isPresented: $isFavePopoverPresented) {
                        
                        FavouritesListView(selection: $selectedCity,
                                           cityList: self.viewModel.getFavouriteCities(fetchedResults: cityFetchedResults))
                        // TODO: ProgressView for loading
                        .presentationCompactAdaptation(.none)
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            .toolbarBackground(setupViewTheme().backgroundColor,
                               for: .bottomBar)
            .accentColor(.white)
            .background(setupViewTheme().backgroundColor)
            .onAppear {
                isWeatherShowing = true
                citySearchActive = false
                isShowingSaveButton = false
                citySearchFocus = self.viewModel.forecastData.isEmpty
                
                for city in cityFetchedResults {
                    print("The stored city name in \(cityFetchedResults.firstIndex(of: city)) is \(city.cityName)")
                    print("The stored city currentTemp in \(String(describing: city.index)) is \(city.currentTemp)")
                    print("The stored city maxTemP in \(String(describing: city.index)) is \(city.maxTemp)")
                }
                
                for forecast in forecastFetchedResults {
                    print("The stored forecast name in \(forecastFetchedResults.firstIndex(of: forecast)) is \(forecast.cityName)")
                    print("The stored forecast condition in \(forecastFetchedResults.firstIndex(of: forecast)) is \(forecast.condition)")
                    print("The stored forecast currentTemp in \(String(describing: forecast.index)) is \(forecast.currentTemp)")
                    print("The stored forecast maxTemP in \(String(describing: forecast.index)) is \(forecast.dayOfWeek)")
                }
            }
            .searchable(text: $cityText,
                        isPresented: $citySearchActive,
                        prompt: "")
            .searchFocused($citySearchFocus)
            .onSubmit(of: .search) {
                // TODO: ProgressView for loading
                if !self.cityText.isEmpty {
                    
                    WeatherLocation.sharedInstance.city = cityText
                    isShowingSaveButton = true
                    
                    Task {
                        await self.viewModel.getCityWeather()
                    }
                }
            }
            .onChange(of: selectedCity) {
                self.viewModel.todayWeatherDetails = selectedCity ?? self.viewModel.todayWeatherDetails
                
                self.viewModel.getFavCityForecast(favouriteCity: self.viewModel.todayWeatherDetails.city,
                                                  viewContext: self.viewContext)
            }
        }
    }
}



#Preview {
    let viewModel = WeatherViewModel(weatherDetails: TodaysWeatherDetails(city: WeatherConstants.previewCity,
                                                                          minTemperature: WeatherConstants.previewCityMinTempTitle,
                                                                          currentTemperature: WeatherConstants.previewCityTempTitle,
                                                                          maxTemperature: WeatherConstants.previewCityMaxTempTitle,
                                                                          id: 0, dt: 1748206800),
                                     weatherForcast: WeatherConstants.previewForecast)
    
    WeatherView(viewModel: viewModel)
}
