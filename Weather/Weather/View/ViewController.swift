//
//  ViewController.swift
//  Weather
//
//  Created by Anil Reddy on 19/08/24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var skyTypeLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var presentLocation: CLLocation?
    
    let viewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        viewModel.getWeather(location: "Frisco")
        observeEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupLoation()
    }

    func setupLoation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func observeEvent() {
        viewModel.eventHandler = { [weak self] event in
            guard let self else { return }

            switch event {
            case .loading:
                print("Weather loading....")
            case .stopLoading:
                // Indicator hide kardo
                print("Stop loading...")
            case .dataLoaded:
                print("Data loaded...")
                DispatchQueue.main.async {
                    self.loadWeather()
                }
            case .error(let error):
                print(error)
                DispatchQueue.main.async {
                    self.loadEmptyWeather()
                }
            }
        }
    }
    
    func loadWeather() {
        locationLabel.text = viewModel.weatherDetails?.name
        dateLabel.text = "\((viewModel.weatherDetails?.dt ?? 0).convertToFormat())"
        temperatureLabel.text = "Average Temperature: \(Int(viewModel.weatherDetails?.main.temp ?? 0))° C"
        pressureLabel.text = "Pressure: \(viewModel.weatherDetails?.main.pressure ?? 0) hPa"
        humidityLabel.text = "Humidity: \(viewModel.weatherDetails?.main.humidity ?? 0)%"
        skyTypeLabel.text = "\(viewModel.weatherDetails?.weather.first?.description ?? "")".uppercased()
        feelsLikeTemperatureLabel.text = "Feels Like: \(Int(viewModel.weatherDetails?.main.feelsLike ?? 0))° C"
        visibilityLabel.text = "Visibility: \((viewModel.weatherDetails?.visibility ?? 0)/1000) Km"
    }
    
    func loadEmptyWeather() {
        locationLabel.text = "🔎 No Search Results."
        dateLabel.text = ""
        temperatureLabel.text = ""
        pressureLabel.text = ""
        humidityLabel.text = ""
        skyTypeLabel.text = ""
        feelsLikeTemperatureLabel.text = ""
        visibilityLabel.text = ""
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.getWeather(location: searchBar.text ?? "Frisco")
        searchBar.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = ""
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            presentLocation = locations.first!
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        guard let presentLocation = presentLocation else {
            return
        }
        
        let latitude = presentLocation.coordinate.latitude
        let longitude = presentLocation.coordinate.longitude
        print("Latitude:\(latitude) Longitude: \(longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
}

