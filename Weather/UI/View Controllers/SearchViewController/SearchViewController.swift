//
//  SearchViewController.swift
//  Weather
//
//  Created by Arjun Shukla on 3/18/23.
//

import Combine
import Foundation
import SwiftUI
import UIKit

class SearchViewController: UIViewController, Storyboarded {
    
    @IBOutlet private weak var citySearchBar: UISearchBar!
    
    @IBOutlet private weak var forecastStackView: UIStackView!
    
    private var viewModel = SearchViewModel(apiService: WeatherAPIHelper())

    private var cancellables = Set<AnyCancellable>()
    
    @Published private var forecastModel: ForecastModel = {
        // Placeholder data
        let weatherModel = DisplayWeatherModel(cityName: "Fremont",
                                               mainForecast: "Clouds",
                                               forecastDescription: "Overcast clouds",
                                               forecastIconUrl: URL(string: "https://openweathermap.org/img/wn/10d@2x.png")!)
        
        let temperatureModel = DisplayTemperatureModel(temperature: "15",
                                                       feelLike: "12",
                                                       minTemp: "5",
                                                       maxTemp: "17")
        
        return ForecastModel(showForecast: false,
                             weatherModel: weatherModel,
                             temperatureModel: temperatureModel)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForecastView()
        setupSearchBarBinding()
        setupForecastBinding()
    }
    
    private func setupSearchBarBinding() {
        citySearchBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Bind the view model's searchText property to the search bar
        viewModel.$searchText
            .debounce(for: .milliseconds(700), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.viewModel.executeSearch()
            }
            .store(in: &cancellables)
    }
    
    private func setupForecastBinding() {
        viewModel.$forecastModel
            .sink { [weak self] model in
                if let model = model {
                    self?.forecastModel = model
                }
            }
            .store(in: &cancellables)
    }
    
    func setupForecastView() {
        
        let forecastView = ForecastView(model: forecastModel)
        
        let hostingController = UIHostingController(rootView: forecastView)
        
        forecastStackView.addArrangedSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    hostingController.view.leadingAnchor.constraint(equalTo: forecastStackView.leadingAnchor),
                    hostingController.view.trailingAnchor.constraint(equalTo: forecastStackView.trailingAnchor),
                    hostingController.view.topAnchor.constraint(equalTo: forecastStackView.topAnchor),
                    hostingController.view.bottomAnchor.constraint(equalTo: forecastStackView.bottomAnchor)
                ])
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
}
