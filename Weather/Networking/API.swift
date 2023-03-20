//
//  API.swift
//  Weather
//
//  Created by Arjun Shukla on 3/18/23.
//

import Foundation

class API {
    typealias completion = (Data?, URLResponse?, Error?) -> Void
    private static let apiKey = "4c79191af041154a917fc3ec8d3de430"
    private static let baseWeatherUrlString = "https://api.openweathermap.org/data/2.5/weather"
    private static let baseGeocodeUrlString = "http://api.openweathermap.org/geo/1.0/direct"
    private static let baseIconDownloadUrlString = "https://openweathermap.org/img/wn/"

    private static let lat = "lat"
    private static let lon = "lon"
    private static let appid = "appid"

    static func getForecastUrl(latitude: String, longitude: String) -> URL? {
        // https://api.openweathermap.org/data/2.5/weather?lat=37.3228934&lon=-122.0322895&appid=4c79191af041154a917fc3ec8d3de430
        
        if var components = URLComponents(string: baseWeatherUrlString) {
            
            let queryItems = [
                URLQueryItem(name: lat, value: latitude),
                URLQueryItem(name: lon, value: longitude),
                URLQueryItem(name: appid, value: apiKey)
            ]
            
            components.queryItems = queryItems
            
            if let url = components.url {
                print(url.absoluteString)
                return url
            }
        }

        return nil
    }

    static func getGeocodeUrl(city: String, state: String? = nil, country: String? = nil) -> URL? {
        //http://api.openweathermap.org/geo/1.0/direct?q=cupertino,ca,usa&limit=1&appid=4c79191af041154a917fc3ec8d3de430
        
        if var components = URLComponents(string: baseGeocodeUrlString) {
            
            var query = city
            
            if let state = state {
                query += ",\(state)"
            }
            
            if let country = country {
                query += ",\(country)"
            }
            
            
            let queryItems = [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "limit", value: "1"),
                URLQueryItem(name: appid, value: apiKey)
            ]

            components.queryItems = queryItems

            if let url = components.url {
                print(url.absoluteString)
                return url
            }
        }

        return nil
    }
    
    static func getForecastIconUrl(iconCode: String) -> URL? {
//    https://openweathermap.org/img/wn/10d@2x.png
        
        let iconUrl = baseIconDownloadUrlString + "\(iconCode)@2x.png"
        return URL(string: iconUrl)
    }
    
    static func fetchData<T: Decodable>(url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
