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
    
    @State private var isLoading = false
    @State private var citySearchActive = false
    @FocusState private var citySearchFocus: Bool
    @State private var cityText = ""
    
    @State var isFavePopoverPresented: Bool = false
    @State private var selectedCity: TodaysWeatherDetails? = nil
    @State var cityListHeight: CGFloat = 0
    
    @State var isMapShown: Bool = false
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
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
                
//                if isLoading {
//                    ShortLoaderAlertView()
//                }
            }
            .searchable(text: $cityText,
                        isPresented: $citySearchActive,
                        prompt: "")
            .searchFocused($citySearchFocus)
            .onSubmit(of: .search) {
                
    //            isLoading = true
                print("isLoading is now - ", isLoading)
                
                if !self.cityText.isEmpty {
                    
                    WeatherLocation.sharedInstance.city = cityText
                    
                    Task {
                        await self.viewModel.getCityWeather()
                    }
    //                updateLoading()
                    isShowingSaveButton = true
                }
            }
            .edgesIgnoringSafeArea(.top)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(setupViewTheme().backgroundColor)
            .onAppear {
                isWeatherShowing = true
                citySearchActive = false
                isShowingSaveButton = false
                isLoading = true
                citySearchFocus = self.viewModel.forecastData.isEmpty
                
                printCoreData()
                updateLoading()
            }
        }
        .onChange(of: selectedCity) {
            isShowingSaveButton = false
            
            if let selectedCity = selectedCity {
                self.viewModel.todayWeatherDetails = selectedCity
                
                self.viewModel.getFavCityForecast(favouriteCity: self.viewModel.todayWeatherDetails.city,
                                                  viewContext: self.viewContext)
                
                printCoreData()
            } else {
                citySearchFocus = true
                self.viewModel.todayWeatherDetails = self.viewModel.todayWeatherDetails
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                createToolBar()
                    .popover(isPresented: $isFavePopoverPresented) {
                        
                        FavouritesListView(selection: $selectedCity,
                                           cityList: self.viewModel.getFavouriteCities(fetchedResults: cityFetchedResults))
                        
                        .presentationCompactAdaptation(.none)
                    }
            }
        }
        .tint(Color.white)
        //TODO: Review white the accentColor changes back to blue
        .toolbarBackground(setupViewTheme().backgroundColor,
                           for: .bottomBar)
        .navigationDestination(isPresented: $isMapShown) {
            MapView(cityList: self.viewModel.getFavouriteCities(fetchedResults: cityFetchedResults))
        }
    }
    
    func printCoreData() {
        for city in cityFetchedResults {
            print("The stored city name in \(cityFetchedResults.firstIndex(of: city)) is \(city.cityName)")
            print("The stored city currentTemp in \(String(describing: city.index)) is \(city.currentTemp)")
            print("The stored city lon in \(String(describing: city.index)) is \(city.lon)")
            print("The stored city lat in \(String(describing: city.index)) is \(city.lat)")
        }
        
        for forecast in forecastFetchedResults {
            print("The stored forecast name in \(forecastFetchedResults.firstIndex(of: forecast)) is \(forecast.cityName)")
            print("The stored forecast condition in \(forecastFetchedResults.firstIndex(of: forecast)) is \(forecast.condition)")
            print("The stored forecast currentTemp in \(String(describing: forecast.index)) is \(forecast.currentTemp)")
            print("The stored forecast maxTemP in \(String(describing: forecast.index)) is \(forecast.dayOfWeek)")
        }
    }
    
    func updateLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading.toggle()
        }
        // TODO: Implement Delegation like UIKit to handle when this hides/shows
    }
}

// MARK: Preview Section
#Preview {
    let viewModel = WeatherViewModel(weatherDetails: TodaysWeatherDetails(city: WeatherConstants.previewCity,
                                                                          minTemperature: WeatherConstants.previewCityMinTempTitle,
                                                                          currentTemperature: WeatherConstants.previewCityTempTitle,
                                                                          maxTemperature: WeatherConstants.previewCityMaxTempTitle,
                                                                          id: 0,
                                                                          dt: 1748206800,
                                                                          lat: 18.55,
                                                                          lon: -33.82),
                                     weatherForcast: WeatherConstants.previewForecast)
    
    WeatherView(viewModel: viewModel)
}
