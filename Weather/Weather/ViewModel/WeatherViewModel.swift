//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Anil Reddy on 19/08/24.
//

import Foundation

class WeatherViewModel {
    var networkManager = NetworkManager()
    var eventHandler: ((_ event: Event) -> Void)?
    var weatherDetails: WeatherModel?
    
    
    func getWeather(location: String) {
        let params = ["q":"\(location)", "appid":Constants.apiKey]
        let weatherUrl = createGetURL(baseURL: Constants.baseUrl, params: params)
        networkManager.request(modelType: WeatherModel.self, url: weatherUrl, httpMethod: HttpMethodType.Get) { response in
            switch response {
            case .success(let weather):
                self.weatherDetails = weather
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                self.eventHandler?(.error(error))
            }
        }
    }
    
    func createGetURL(baseURL: String, params: [String: String]) -> URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        if let url = urlComponents?.url {
            return url
        } else {
            return nil
        }
    }
}

extension WeatherViewModel {

    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error)
    }

}
