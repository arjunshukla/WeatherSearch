//
//  Cache.swift
//  Weather
//
//  Created by Arjun Shukla on 3/18/23.
//

import Foundation

class Cache {
    static var imageCache = NSCache<AnyObject, AnyObject>()
    static var geocodeCache = NSCache<AnyObject, AnyObject>()
}
