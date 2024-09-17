//
//  WeatherViewModel.swift
//  WeatherAppVirtusa
//
//  Created by Rajagopal Ganesan on 17/09/24.
//

import Foundation

// MARK: - WeatherViewModel

// Manages data and logic for the weather view
class WeatherViewModel {
    var weatherService = WeatherService() //Changing it to var for unit testing
    
    // Callbacks for updating the view
    var onWeatherUpdate: ((Weather) -> Void)?
    var onError: ((String) -> Void)?
    
    // Fetches weather data and updates the view
    func fetchWeather(for city: String) {
        weatherService.fetchWeather(for: city) { [weak self] result in
            switch result {
            case .success(let weather):
                self?.onWeatherUpdate?(weather)
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
}
