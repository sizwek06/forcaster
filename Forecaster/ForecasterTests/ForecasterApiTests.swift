//
//  ForecasterTests.swift
//  ForecasterTests
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import XCTest
@testable import Forecaster

final class ForecasterTests: XCTestCase {

    private var weatherRequestsMock: WeatherApiMockHelper!
    
    let weatherApiMock = WeatherApiMockHelper()
    
    override func setUpWithError() throws {
        weatherRequestsMock = WeatherApiMockHelper()
    }

    override func tearDownWithError() throws {
        weatherRequestsMock.reset()
        weatherRequestsMock = nil
    }

    func testWeather() async throws {
        do {
            weatherApiMock.invokeWeather = true
            let result = try await weatherApiMock.asyncRequest(endpoint: WeatherEndpoints.getCurrent,
                                                               responseModel: OpenWeather.self)
            XCTAssertEqual(result.name, "Durban")
            
            XCTAssertEqual(result.cod, 200)
            XCTAssertEqual(result.base, "stations")
            
            XCTAssertEqual(result.main.currentTemp, "21º")
            XCTAssertEqual(result.main.highDescription, "21º")
            XCTAssertEqual(result.main.lowDescription, "16º")
            
            XCTAssertEqual(result.weather[0].id, 800)
        } catch {
            print(error)
            throw error
        }
    }

    func testWeatherForecast() async throws {
        do {
            weatherApiMock.invokeForecast = true
            let result = try await weatherApiMock.asyncRequest(endpoint: WeatherEndpoints.getCurrent,
                                                               responseModel: Forecast.self)
            
            XCTAssertEqual(result.cod, "200")
            XCTAssertEqual(result.message, 0)
            XCTAssertEqual(result.cnt, 1)
            
            XCTAssertEqual(result.list[0].dt, 1748422800)
            XCTAssertEqual(result.list[0].temp.temp, 19.08)
            XCTAssertEqual(result.list[0].weather[0].id, 800)

        } catch {
            print(error)
            throw error
        }
    }
    
//    func testAllWeather() async throws {
//        weatherApiMock.invokeForecast = true
//        weatherApiMock.invokeWeather = true
//        
//        viewModelUnderTest.locationManager.location?.coordinate = 33.33
//        
//        await viewModelUnderTest.getWeather()
//        
//        await MainActor.run {
//            XCTAssertEqual(viewModelUnderTest.weatherDetails?.city, "200")
//            
//            XCTAssertEqual(viewModelUnderTest.weatherDetails?.id, 200)
//            
//            XCTAssertEqual(viewModelUnderTest.weatherDetails?.currentTemperature, "21º")
//            XCTAssertEqual(viewModelUnderTest.weatherDetails?.maxTemperature, "21º")
//            XCTAssertEqual(viewModelUnderTest.weatherDetails?.minTemperature, "16º")
//            
//            XCTAssertEqual(viewModelUnderTest.forecastData[0].dt, 11234242424)
//            XCTAssertEqual(viewModelUnderTest.forecastData[0].temperature, "1")
//            
//            XCTAssertEqual(viewModelUnderTest.forecastData[0].weather.first?.id, 200)
//            
//            XCTAssertNotNil(viewModelUnderTest.createFiveDayForecast())
//        }
//    }
    // TODO: Mock location Services and mock location
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
