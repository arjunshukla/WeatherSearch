//
//  WeatherAPIHelper.swift
//  Weather
//
//  Created by Arjun Shukla on 3/18/23.
//

import Foundation

protocol SomeWeatherService {
    func fetchForecast(lat: String,
                       lon: String) async throws -> WeatherData?
    
    func fetchGeocode(city: String,
                      state: String?,
                      country: String?) async throws -> City?
}

class WeatherAPIHelper: SomeWeatherService {
    
    func fetchForecast(lat: String,
                       lon: String) async throws -> WeatherData? {
        guard let url = API.getForecastUrl(latitude: lat,
                                           longitude: lon)
        else {
            return nil
        }
        
        let weatherData: WeatherData = try await API.fetchData(url: url)
        
        return weatherData
    }
    
    func fetchGeocode(city: String,
                      state: String?,
                      country: String?) async throws -> City? {
        
        guard let url = API.getGeocodeUrl(city: city,
                                          state: state,
                                          country: country)
        else { return nil }
        
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
