//
//  SearchViewController.swift
//  Weather
//
//  Created by Arjun Shukla on 3/18/23.
//

import Combine
import CoreLocation
import Foundation
import SwiftUI
import UIKit

class SearchViewController: UIViewController, Storyboarded {
    
    @IBOutlet private weak var citySearchBar: UISearchBar!
    
    @IBOutlet private weak var forecastStackView: UIStackView!
    
    private var hostingController: UIHostingController<ForecastView>?
    private var forecastView: ForecastView?

    private var viewModel = SearchViewModel(apiService: WeatherAPIHelper())

    private var cancellables = Set<AnyCancellable>()
    
    private let locationManager = CLLocationManager()
    
    private var userLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBarBinding()
        setupForecastBinding()
        
        setupLocationService()        
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
                guard let self = self,
                      let model = model else { return }

                DispatchQueue.main.async {
                    self.hostingController == nil ? self.setupForecastView(forecastModel: model) : self.updateForecastView(forecastModel: model)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateForecastView(forecastModel: ForecastModel) {
        forecastView = ForecastView(model: forecastModel)
        hostingController?.rootView = forecastView!
//        hostingController = UIHostingController(rootView: forecastView!)
    }
    
    private func setupForecastView(forecastModel: ForecastModel) {
        
        forecastView = ForecastView(model: forecastModel)
        
        hostingController = UIHostingController(rootView: forecastView!)
        
        guard let hostingController = hostingController else { return }

        forecastStackView.addArrangedSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    hostingController.view.leadingAnchor.constraint(equalTo: forecastStackView.leadingAnchor),
                    hostingController.view.trailingAnchor.constraint(equalTo: forecastStackView.trailingAnchor),
                    hostingController.view.topAnchor.constraint(equalTo: forecastStackView.topAnchor),
                    hostingController.view.bottomAnchor.constraint(equalTo: forecastStackView.bottomAnchor)
                ])
    }
    
    private func setupLocationService() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if userLocation == nil {
            locationManager.startUpdatingLocation()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
}

extension SearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last,
        userLocation == nil else { return }
        
        userLocation = location.coordinate
        print("Latitude: \(location.coordinate.latitude)")
        print("Longitude: \(location.coordinate.longitude)")
        locationManager.stopUpdatingLocation()
        
        // Fetch weather forecast for user's location
        
        viewModel.fetchForecast(lat: String(location.coordinate.latitude), lon: String(location.coordinate.longitude))
    }
}
