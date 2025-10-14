//
//  AppCoordinator.swift
//  Shopflow
//
//  Created by Rodrigo Cerqueira Reis on 26/09/25.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    private var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        startHomeFlow()
    }
    
    private func startHomeFlow() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}
