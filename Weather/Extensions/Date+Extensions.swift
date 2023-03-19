//
//  Date+Extensions.swift
//  Weather
//
//  Created by Arjun Shukla on 3/18/23.
//

import Foundation

extension Date {
    var tomorrowDay: Date {
        Date().dayAfter
    }

    var dayAfter: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }
}
