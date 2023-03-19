//
//  SearchViewControllerViewModel.swift
//  Weather
//
//  Created by Arjun Shukla on 3/18/23.
//

import Foundation
import Combine

@MainActor final class SearchViewModel {
    
    @Published var searchText = ""
    
    @Published var weather: Weather? {
        didSet {
            createForecastModel()
        }
    }
    
    @Published var forecastModel: ForecastModel?

    @Published var city: City? {
        didSet {
            fetchForecast()
        }
    }
    private var temperatureData: Main?
    private var weatherAPIHelper: SomeWeatherService
    
    init(apiService: SomeWeatherService) {
        self.weatherAPIHelper = apiService as! WeatherAPIHelper
    }
    
    func executeSearch() {
        // Perform the search with the given search text
        print("Searching for \(searchText)")
        Task {
            do {
                city = try await weatherAPIHelper.fetchGeocode(city: searchText, state: nil, country: nil)
                print(city)
            } catch {
                print("Error while fetching geocode info for seacrh term \(searchText):\n \(error.localizedDescription)")
            }
        }
    }
    
    func fetchForecast() {
        Task {
            do {
                guard let city = city else {
                    return
                }

                let lat = String(city.latitude)
                let lon = String(city.longitude)

                let weatherData = try await weatherAPIHelper.fetchForecast(lat: lat, lon: lon)
                weather = weatherData?.weather.first
                temperatureData = weatherData?.main
                print(weather)
            } catch {
                print("Error while fetching forecast for \(city?.name): \(error.localizedDescription)")
            }
        }
    }
    
    func createForecastModel() {
        guard let city = city,
              let weather = weather,
              let temperature = temperatureData
        else { return }
        
        let weatherModel = DisplayWeatherModel(
            cityName: city.name,
            mainForecast: weather.main,
            forecastDescription: weather.description,
            forecastIconUrl: API.getForecastIconUrl(iconCode: weather.icon))
        
        let temperatureModel = DisplayTemperatureModel(
            temperature: String(temperature.temp),
            feelLike: String(temperature.feels_like),
            minTemp: String(temperature.temp_min),
            maxTemp: String(temperature.temp_max))
        
        forecastModel = ForecastModel(showForecast: true, weatherModel: weatherModel, temperatureModel: temperatureModel)

        print(forecastModel)
    }
}
