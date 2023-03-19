//
//  Coordinator.swift
//  Weather
//
//  Created by Arjun Shukla on 3/18/23.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
