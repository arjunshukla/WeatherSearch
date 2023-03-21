//
//  SearchViewControllerViewModel.swift
//  Weather
//
//  Created by Arjun Shukla on 3/18/23.
//

import Foundation
import Combine

final class SearchViewModel {

    // MARK: Published properties
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var forecastModel: ForecastModel?
    @Published var showError = false

    // MARK: Private properties
    private var weather: Weather?
    private var city: City?
    private var cityName: String?
    private var temperatureData: Main?
    private var weatherAPIHelper: SomeWeatherService
    
    init(apiService: SomeWeatherService) {
        self.weatherAPIHelper = apiService as! WeatherAPIHelper
    }
    
    // MARK: Functions
    
    /// Looks up city coordinates to fetch weather info
    func executeSearch() {
        guard !searchText.isEmpty else { return }
        // Perform the search with the given search text
        print("⚡️ Searching for: \(searchText)")
        Task {
            do {
                isLoading = true
                city = try await weatherAPIHelper.fetchGeocode(city: searchText, state: nil, country: nil)
                print(String(describing: city))
                isLoading = false
                fetchForecast()
            } catch {
                isLoading = false
                showError = true
                print("⚡️ Error while fetching geocode info for seacrh term \(searchText):\n \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchForecast() {
        Task {
            do {
                guard let city = city else { return }

                let lat = String(city.latitude)
                let lon = String(city.longitude)
                
                isLoading = true
                
                let weatherData = try await weatherAPIHelper.fetchForecast(lat: lat, lon: lon)
                
                UserDefaults.standard.set(lat, forKey: UserDefaultKeys.latitude)
                UserDefaults.standard.set(lon, forKey: UserDefaultKeys.longitude)
                
                isLoading = false
                
                extractForecastData(from: weatherData)
            } catch {
                isLoading = false
                showError = true
                print("⚡️ Error while fetching forecast for \(String(describing: city?.name)): \(error.localizedDescription)")
            }
        }
    }
    
    func fetchForecast(lat: String, lon: String) {
        Task {
            do {
                isLoading = true
                let weatherData = try await weatherAPIHelper.fetchForecast(lat: lat, lon: lon)
                isLoading = false
                extractForecastData(from: weatherData)
            } catch {
                isLoading = false
                showError = true
                print("⚡️ Error while fetching forecast for lat: \(lat), lon: \(lon) \n \(error.localizedDescription)")
                
            }
        }
    }

    private func extractForecastData(from weatherData: WeatherData?) {
        guard let weatherData = weatherData else { return }

        weather = weatherData.weather.first
        temperatureData = weatherData.main
        cityName = weatherData.name
        print(String(describing: weather))
        createForecastModel()
    }

    private func createForecastModel() {
        guard let cityName = cityName,
              let weather = weather,
              let temperature = temperatureData
        else {
            print("⚡️ Missing key data")
            return
        }
        
        let weatherModel = DisplayWeatherModel(
            cityName: cityName,
            mainForecast: weather.main,
            forecastDescription: weather.description.sentenceCased,
            forecastIconUrl: API.getForecastIconUrl(iconCode: weather.icon))
        
        let temperatureModel = DisplayTemperatureModel(
            temperature: temperature.temp.imperialTemperature,
            feelLike: temperature.feels_like.imperialTemperature,
            minTemp: temperature.temp_min.imperialTemperature,
            maxTemp: temperature.temp_max.imperialTemperature)
        
        forecastModel = ForecastModel(showForecast: true, weatherModel: weatherModel, temperatureModel: temperatureModel)

//        print("⚡️ New forecastModel: ", String(describing: forecastModel))
    }
}
