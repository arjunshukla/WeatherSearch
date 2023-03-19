//
//  LocationHelper.swift
//  Weather
//
//  Created by Arjun Shukla on 3/18/23.
//

import Foundation
import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    // Other methods...
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        print("Latitude: \(location.coordinate.latitude)")
        print("Longitude: \(location.coordinate.longitude)")
        
        // Do something with the user's location...
    }

}

//protocol SomeGeocodeService {
//    func fetchGeoCode(for query: String) -> City
//}
//
//class GeocodeAPIService: SomeGeocodeService {}
