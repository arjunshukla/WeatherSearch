//
//  WeatherAPIHelper.swift
//  Weather
//
//  Created by Arjun Shukla on 3/18/23.
//

import Foundation

/// Weather service protocol
protocol SomeWeatherService {
    func fetchForecast(lat: String,
                       lon: String) async throws -> WeatherData?
    
    func fetchGeocode(city: String,
                      state: String?,
                      country: String?) async throws -> City?
}

/// Defines weather service functions conforming to SomeWeatherService protocol
class WeatherAPIHelper: SomeWeatherService {
    
    /// Fetches forecast WeatherData for the passed in latitide and longitude from the Weather API.
    /// - Parameters:
    ///   - lat: Latitude in String
    ///   - lon: Longitude in String
    /// - Returns: WeatherData containing forecast for input params
    func fetchForecast(lat: String,
                       lon: String) async throws -> WeatherData? {
        guard let url = API.getForecastUrl(latitude: lat,
                                           longitude: lon)
        else {
            print("⚡️ Failed to get forecasr url for lat: \(lat), lon: \(lon)")
            return nil
        }
        
        let weatherData: WeatherData = try await API.fetchData(url: url)
        
        return weatherData
    }
    
    /// Fetches coordinates for passed in City(Required), State, Country returning the City model
    /// - Parameters:
    ///   - city: Name of city
    ///   - state: Name of state
    ///   - country: Name of country
    /// - Returns: City model containing latitide and longitude
    func fetchGeocode(city: String,
                      state: String?,
                      country: String?) async throws -> City? {
        
        guard let url = API.getGeocodeUrl(city: city,
                                          state: state,
                                          country: country)
        else {
            print("⚡️ Failed to get geocode url for city: \(city)")
            return nil
        }
        
        let geocodeCacheKey = url as AnyObject
        
        if let cityFromCache = Cache.geocodeCache.object(forKey: geocodeCacheKey),
           let city = cityFromCache as? City {
            return city
        }
        
        let cityList: [City] = try await API.fetchData(url: url)
        
        if let city = cityList.first {
            Cache.geocodeCache.setObject(city as AnyObject, forKey: geocodeCacheKey)
            
            return city
        }

        return nil
    }
}
