//
//  ContentViewModelTests.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/28.
//

import XCTest
@testable import Forecaster

final class ContentViewModelTests: XCTestCase {
    
    private var weatherRequestsMock: WeatherApiMockHelper!
    var viewModelUnderTest: ContentViewModel!
    
    override func setUpWithError() throws {
        weatherRequestsMock = WeatherApiMockHelper()
        viewModelUnderTest = ContentViewModel(apiClient: weatherRequestsMock!,
                                              viewState: ViewState.launch)
    }
    
    override func tearDownWithError() throws {
        weatherRequestsMock.reset()
        weatherRequestsMock = nil
    }
    
    func testWeather() async throws {
        do {
            self.weatherRequestsMock.invokeWeather = true
            await self.viewModelUnderTest.getCurrentWeather()
            
            guard let weatherDetails = await viewModelUnderTest.weatherDetails else { return }
            
            XCTAssertEqual(weatherDetails.city, "Durban")
            XCTAssertEqual(weatherDetails.minTemperature, "16º")
            XCTAssertEqual(weatherDetails.maxTemperature, "21º")
            XCTAssertEqual(weatherDetails.lat, -29.8579)
            XCTAssertEqual(weatherDetails.lon, 31.0292)
        }
    }
    
    
    func testForecast() async throws {
        do {
            self.weatherRequestsMock.invokeForecast = true
            await self.viewModelUnderTest.getWeatherForecast()
            
            let forecastList = await self.viewModelUnderTest.forecastData
            
            XCTAssertEqual(forecastList[0].dt, 1748422800)
            XCTAssertEqual(forecastList[0].temperature, "22º")
            XCTAssertEqual(forecastList[0].temp.temp, 22.08)
            XCTAssertEqual(forecastList[0].weather[0].id, 800)
        }
    }
    
    func testWeatherError() async throws {
        weatherRequestsMock.invokeError = true
        await viewModelUnderTest.getCurrentWeather()
    
        await MainActor.run {
            XCTAssertEqual(viewModelUnderTest.errorCode, "401")
            XCTAssertEqual(viewModelUnderTest.viewState, .error)
            XCTAssertEqual(viewModelUnderTest.errorDescription, "UNKNOWN BACKEND ERROR")
        }
    }
    
    func testWeatherForecast() async throws {
        do {
            weatherRequestsMock.invokeForecast = true
            await self.viewModelUnderTest.getWeatherForecast()
            
            await MainActor.run {
                XCTAssertEqual(self.viewModelUnderTest.forecastData[0].dt, 1748422800)
                XCTAssertEqual(self.viewModelUnderTest.forecastData[0].temp.temp, 22.08)
                XCTAssertEqual(self.viewModelUnderTest.forecastData[0].weather[0].id, 800)
                XCTAssertNotNil(viewModelUnderTest.createFiveDayForecast())
            }
        }
    }

    func testForecastError() async throws {
        weatherRequestsMock.invokeError = true
        await viewModelUnderTest.getWeatherForecast()
    
        await MainActor.run {
            XCTAssertEqual(viewModelUnderTest.errorCode, "401")
            XCTAssertEqual(viewModelUnderTest.viewState, .error)
            XCTAssertEqual(viewModelUnderTest.errorDescription, "UNKNOWN BACKEND ERROR")
        }
    }
}
