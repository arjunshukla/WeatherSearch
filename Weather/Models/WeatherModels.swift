//
//  Models.swift
//  Weather
//
//  Created by Arjun Shukla on 3/18/23.
//

import Foundation
/* Models for Weather forecast api data
 {
     "coord": {
         "lon": -122.0317,
         "lat": 37.3203
     },
     "weather": [
         {
             "id": 803,
             "main": "Clouds",
             "description": "broken clouds",
             "icon": "04d"
         }
     ],
     "base": "stations",
     "main": {
         "temp": 290.68,
         "feels_like": 290,
         "temp_min": 285.68,
         "temp_max": 293.28,
         "pressure": 1016,
         "humidity": 58
     },
     "visibility": 10000,
     "wind": {
         "speed": 4.63,
         "deg": 200
     },
     "clouds": {
         "all": 75
     },
     "dt": 1679162000,
     "sys": {
         "type": 2,
         "id": 2001717,
         "country": "US",
         "sunrise": 1679148895,
         "sunset": 1679192252
     },
     "timezone": -25200,
     "id": 5341145,
     "name": "Cupertino",
     "cod": 200
 }
 */

struct WeatherData: Decodable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct Coord: Decodable {
    let lon: Double
    let lat: Double
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Decodable {
    let speed: Double
    let deg: Int
}

struct Clouds: Decodable {
    let all: Int
}

struct Sys: Decodable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}
