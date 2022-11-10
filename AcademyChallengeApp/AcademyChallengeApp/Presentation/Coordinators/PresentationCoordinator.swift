//
//  PresentationCoordinator.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 10/11/2022.
//

import Foundation
import UIKit

protocol PresentationCoordinator: Coordinator {
    var rootViewController: UIViewController { get }
}

extension PresentationCoordinator {
    func presentCoordinator(_ childCoordinator: PresentationCoordinator, animated: Bool) {
        addChildCoordinator(childCoordinator)
        childCoordinator.start()
        rootViewController.present(childCoordinator.rootViewController, animated: animated)
    }

    func dismissCoordinator(_ childCoordinator: PresentationCoordinator, animated: Bool) {
        childCoordinator.rootViewController.dismiss(animated: animated)
        removeChildCoordinator(childCoordinator)
    }
}
