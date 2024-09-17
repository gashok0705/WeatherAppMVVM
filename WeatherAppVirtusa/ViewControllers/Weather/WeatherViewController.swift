//
//  WeatherViewController.swift
//  WeatherAppVirtusa
//
//  Created by Rajagopal Ganesan on 17/09/24.
//
import UIKit
import Kingfisher
import CoreLocation

// MARK: - WeatherViewController

class WeatherViewController: UIViewController {
    private let viewModel = WeatherViewModel()

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up bindings for ViewModel updates
        setupBindings()

        // Auto-load the last searched city
        autoLoadLastCity()

        // Request location access
        requestLocationAccess()
    }

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        // Fetch weather for the entered city
        guard let city = cityTextField.text, !city.isEmpty else {
            return
        }
        viewModel.fetchWeather(for: city)
    }

    private func setupBindings() {
        // Handle successful weather updates
        viewModel.onWeatherUpdate = { [weak self] weather in
            self?.updateUI(with: weather)
        }
        
        // Handle errors
        viewModel.onError = { [weak self] errorMessage in
            self?.errorLabel.text = errorMessage
        }
    }

    private func updateUI(with weather: Weather) {
        // Update UI with weather information
        temperatureLabel.text = "\(weather.main.temp)°F"
        humidityLabel.text = "Humidity: \(weather.main.humidity)%"
        descriptionLabel.text = weather.weather.first?.description
        
        // Load and cache weather icon
        let iconURL = URL(string: "http://openweathermap.org/img/wn/\(weather.weather.first?.icon ?? "01d")@2x.png")
        weatherIconImageView.kf.setImage(with: iconURL)
        
        // Cache the last searched city
        UserDefaults.standard.setValue(cityTextField.text, forKey: "lastSearchedCity")
    }

    private func autoLoadLastCity() {
        // Fetch weather for the last searched city if available
        if let lastCity = UserDefaults.standard.string(forKey: "lastSearchedCity") {
            viewModel.fetchWeather(for: lastCity)
        }
    }

    private func requestLocationAccess() {
        // Request user location access
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Handle location authorization status
        if status == .authorizedWhenInUse {
            // Fetch weather for current location
            if let location = manager.location {
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
                    if let city = placemarks?.first?.locality {
                        self?.viewModel.fetchWeather(for: city)
                    }
                }
            }
        }
    }
}
