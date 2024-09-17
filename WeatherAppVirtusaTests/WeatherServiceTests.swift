//
//  WeatherServiceTests.swift
//  WeatherAppVirtusaTests
//
//  Created by Rajagopal Ganesan on 17/09/24.
//

import XCTest
@testable import WeatherAppVirtusa

// MARK: - WeatherViewModelTests

class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var weatherServiceMock: WeatherServiceMock!

    override func setUp() {
        super.setUp()
        weatherServiceMock = WeatherServiceMock()
        viewModel = WeatherViewModel()
        viewModel.weatherService = weatherServiceMock
    }

    override func tearDown() {
        viewModel = nil
        weatherServiceMock = nil
        super.tearDown()
    }

    func testFetchWeatherSuccess() {
        // Prepare mock data
        let weather = Weather(main: Main(temp: 75.0, humidity: 50.0), weather: [WeatherDetail(description: "Clear sky", icon: "01d")], name: "San Francisco")
        weatherServiceMock.weather = weather

        // Expectation to verify async operation
        let expectation = self.expectation(description: "Weather fetch succeeds")
        
        viewModel.onWeatherUpdate = { fetchedWeather in
            XCTAssertEqual(fetchedWeather.name, "San Francisco")
            XCTAssertEqual(fetchedWeather.main.temp, 75.0)
            XCTAssertEqual(fetchedWeather.weather.first?.description, "Clear sky")
            expectation.fulfill()
        }
        
        viewModel.fetchWeather(for: "San Francisco")
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testFetchWeatherFailure() {
        // Prepare mock error
        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network Error"])
        weatherServiceMock.error = error

        // Expectation to verify async operation
        let expectation = self.expectation(description: "Weather fetch fails")
        
        viewModel.onError = { errorMessage in
            XCTAssertEqual(errorMessage, "Network Error")
            expectation.fulfill()
        }
        
        viewModel.fetchWeather(for: "Invalid City")
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

// MARK: - WeatherServiceMock

// Mock implementation of WeatherService for testing
class WeatherServiceMock: WeatherService {
    var weather: Weather?
    var error: Error?
    
    override func fetchWeather(for city: String, completion: @escaping (Result<Weather, Error>) -> Void) {
        if let weather = weather {
            completion(.success(weather))
        } else if let error = error {
            completion(.failure(error))
        }
    }
}
