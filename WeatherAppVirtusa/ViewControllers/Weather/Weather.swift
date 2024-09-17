//
//  Weather.swift
//  WeatherAppVirtusa
//
//  Created by Rajagopal Ganesan on 17/09/24.
//

import Foundation

// MARK: - Weather Model

// Represents the structure of the weather data returned from the API
struct Weather: Codable {
    let main: Main
    let weather: [WeatherDetail]
    let name: String
}

// Contains information about the weather conditions
struct Main: Codable {
    let temp: Double
    let humidity: Double
}

// Represents individual weather condition details
struct WeatherDetail: Codable {
    let description: String
    let icon: String
}

