//
//  Double+Extension.swift
//  Weather
//
//  Created by Arjun Shukla on 3/19/23.
//

import Foundation

extension Double {
    var imperialTemperature: String {
        String(format: "%.0f\u{00B0} F", self)
    }
}
