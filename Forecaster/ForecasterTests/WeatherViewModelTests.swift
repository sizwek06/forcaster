//
//  WeatherViewModelTests.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/28.
//

import XCTest
@testable import Forecaster

final class WeatherViewModelTests: XCTestCase {
    
    private var weatherRequestsMock: WeatherApiMockHelper!
    var viewModelUnderTest: WeatherViewModel!
    
    let weatherApiMock = WeatherApiMockHelper()
    
    override func setUpWithError() throws {
        let weather = [Weather(id: 200)]
        let forecast = [ForecastList(dt: 1748012400, temp: Temp(temp: 21.51), weather: weather)]
        
        let todaysWeatherDetails = TodaysWeatherDetails(city: WeatherConstants.previewCity,
                                                         minTemperature: WeatherConstants.previewCityMinTempTitle,
                                                         currentTemperature: WeatherConstants.previewCityTempTitle,
                                                         maxTemperature: WeatherConstants.previewCityMaxTempTitle,
                                                         id: 0,
                                                         dt: 1748206800,
                                                         lat: 18.55,
                                                         lon: -33.82)
        
        weatherRequestsMock = WeatherApiMockHelper()
        viewModelUnderTest = WeatherViewModel(apiClient: weatherRequestsMock!,
                                              weatherDetails: todaysWeatherDetails,
                                              weatherForcast: forecast)
    }
    
    override func tearDownWithError() throws {
        weatherRequestsMock.reset()
        weatherRequestsMock = nil
    }
    
    func testCityWeather() async throws {
        do {
            self.weatherRequestsMock.invokeWeather = true
            await self.viewModelUnderTest.getCityCurrentWeather()
            
            guard let weatherDetails = viewModelUnderTest.todayWeatherDetails else { return }
            
            XCTAssertEqual(weatherDetails.city, "Durban")
            XCTAssertEqual(weatherDetails.minTemperature, "16º")
            XCTAssertEqual(weatherDetails.maxTemperature, "21º")
            XCTAssertEqual(weatherDetails.lat, -29.8579)
            XCTAssertEqual(weatherDetails.lon, 31.0292)
        }
    }
    
    func testCityWeatherError() async throws {
        weatherRequestsMock.invokeError = true
        await viewModelUnderTest.getCityCurrentWeather()
    
        await MainActor.run {
            XCTAssertEqual(viewModelUnderTest.errorCode, "401")
            XCTAssertEqual(viewModelUnderTest.errorDescription, "UNKNOWN BACKEND ERROR")
        }
    }
    
    func testCityForecast() async throws {
        do {
            weatherRequestsMock.invokeForecast = true
            await self.viewModelUnderTest.getCityWeatherForecast()
            
            let result = self.viewModelUnderTest.forecastData
            
            await MainActor.run {
                XCTAssertEqual(result[0].dt, 1748552400)
                XCTAssertEqual(result[0].temp.temp, 18.45)
                XCTAssertEqual(result[0].weather[0].id, 800)
                
                XCTAssertNotNil(viewModelUnderTest.createFiveDayForecast())
            }
        }
    }
    
    func testCityForecastError() async throws {
        weatherRequestsMock.invokeError = true
        await viewModelUnderTest.getCityWeatherForecast()
    
        await MainActor.run {
            XCTAssertEqual(viewModelUnderTest.errorCode, "401")
            XCTAssertEqual(viewModelUnderTest.errorDescription, "UNKNOWN BACKEND ERROR")
        }
    }
}
