//
//  MainCoordinator.swift
//  Weather
//
//  Created by Arjun Shukla on 3/18/23.
//

import UIKit

/// Main coordinator for initiating the first screen in the app
class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = SearchViewController.instantiate()
        navigationController.pushViewController(vc, animated: false)
    }
}
