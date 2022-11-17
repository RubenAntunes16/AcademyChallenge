//
//  Coordinator.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 23/09/2022.
//

import Foundation

protocol Coordinator: AnyObject {

    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func addToChildCoordinators(childCoordinator: Coordinator) {
        childCoordinators.append(childCoordinator)
    }

    func removeFromChildCoordinators(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
    }
}
