//
//  Geocode.swift
//  Weather
//
//  Created by Arjun Shukla on 3/18/23.
//

import Foundation
/*
 [
     {
         "name": "Cupertino",
         "local_names": {
             "zh": "库柏蒂诺",
             "en": "Cupertino"
         },
         "lat": 37.3228934,
         "lon": -122.0322895,
         "country": "US",
         "state": "California"
     }
 ]
 */

struct City: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let state: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "lon"
        case country
        case state
    }
}

