//
//  WeatherService.swift
//  WeatherAppVirtusa
//
//  Created by Rajagopal Ganesan on 17/09/24.
//

// MARK: - Weather Service
import Alamofire
// Responsible for fetching weather data from the OpenWeatherMap API
class WeatherService {
    private let apiKey = "a0232e2c0c5df115f0e833c129aa9f9e"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    // Fetches weather information for a given city
    func fetchWeather(for city: String, completion: @escaping (Result<Weather, Error>) -> Void) {
        let parameters: [String: String] = [
            "q": city,
            "appid": apiKey,
            "units": "imperial" // Use Fahrenheit for temperature
        ]

        // Perform network request using Alamofire
        AF.request(baseURL, parameters: parameters).validate().responseDecodable(of: Weather.self) { response in
            switch response.result {
            case .success(let weather):
                completion(.success(weather))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
