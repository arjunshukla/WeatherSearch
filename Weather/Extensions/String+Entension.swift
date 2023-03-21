//
//  String+Entension.swift
//  Weather
//
//  Created by Arjun Shukla on 3/19/23.
//

import Foundation

extension String {
    /// Formats a string in sentense case, capitalizing only the first letter of first word
    var sentenceCased: String {
        guard !self.isEmpty else {
            return ""
        }

        let first = self.prefix(1).capitalized
        let other = self.dropFirst()
        return first + other
    }
}

