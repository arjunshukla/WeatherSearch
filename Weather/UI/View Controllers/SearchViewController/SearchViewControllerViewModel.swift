//
//  SearchViewControllerViewModel.swift
//  Weather
//
//  Created by Arjun Shukla on 3/18/23.
//

import Foundation
import Combine

final class SearchViewModel {
    
    @Published var searchText = ""

    @Published var forecastModel: ForecastModel?

    private var weather: Weather?
    private var city: City?
    private var cityName: String?
    private var temperatureData: Main?
    private var weatherAPIHelper: SomeWeatherService
    
    init(apiService: SomeWeatherService) {
        self.weatherAPIHelper = apiService as! WeatherAPIHelper
    }
    
    func executeSearch() {
        guard !searchText.isEmpty else { return }
        // Perform the search with the given search text
        print("Searching for: \(searchText)")
        Task {
            do {
                city = try await weatherAPIHelper.fetchGeocode(city: searchText, state: nil, country: nil)
                print(String(describing: city))
                
                fetchForecast()
            } catch {
                print("Error while fetching geocode info for seacrh term \(searchText):\n \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchForecast() {
        Task {
            do {
                guard let city = city else { return }

                let lat = String(city.latitude)
                let lon = String(city.longitude)

                let weatherData = try await weatherAPIHelper.fetchForecast(lat: lat, lon: lon)
                extractForecastData(from: weatherData)
            } catch {
                print("Error while fetching forecast for \(String(describing: city?.name)): \(error.localizedDescription)")
            }
        }
    }
    
    func fetchForecast(lat: String, lon: String) {
        Task {
            do {
                let weatherData = try await weatherAPIHelper.fetchForecast(lat: lat, lon: lon)
                extractForecastData(from: weatherData)
            } catch {
                print("Error while fetching forecast for lat: \(lat), lon: \(lon) \n \(error.localizedDescription)")
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
            print("Missing key data")
            return
        }
        
        let weatherModel = DisplayWeatherModel(
            cityName: cityName,
            mainForecast: weather.main,
            forecastDescription: weather.description,
            forecastIconUrl: API.getForecastIconUrl(iconCode: weather.icon))
        
        let temperatureModel = DisplayTemperatureModel(
            temperature: String(temperature.temp),
            feelLike: String(temperature.feels_like),
            minTemp: String(temperature.temp_min),
            maxTemp: String(temperature.temp_max))
        
        forecastModel = ForecastModel(showForecast: true, weatherModel: weatherModel, temperatureModel: temperatureModel)

        print("New forecastModel: ", String(describing: forecastModel))
    }
}
