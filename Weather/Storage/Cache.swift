//
//  Cache.swift
//  Weather
//
//  Created by Arjun Shukla on 3/18/23.
//

import Foundation
import UIKit
import SwiftUI

class Cache {
    static var imageCache = NSCache<AnyObject, AnyObject>()
    static var geocodeCache = NSCache<AnyObject, AnyObject>()
}

// URLCache+imageCache.swift

extension URLCache {
    
    static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}
