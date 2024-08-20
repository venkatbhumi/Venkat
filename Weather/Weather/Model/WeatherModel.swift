//
//  WeatherModel.swift
//  Weather
//
//  Created by Anil Reddy on 19/08/24.
//

import Foundation

struct WeatherModel: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

struct Clouds: Codable {
    let all: Int
}

struct Coord: Codable {
    let lon, lat: Double
}

struct Main: Codable {
    @CelciusScale var temp: Double
    @CelciusScale var feelsLike: Double
    let tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

@propertyWrapper
struct CelciusScale:Codable {

    var wrappedValue: Double = 0.0


    enum CodingKeys: CodingKey {}

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dbl = try? container.decode(Double.self) {
            wrappedValue = (dbl - 273.0)
        }
        if let dbl = try? container.decode(Int
            .self) {
            wrappedValue = (Double(dbl) - 273.0)
        }

    }
}


