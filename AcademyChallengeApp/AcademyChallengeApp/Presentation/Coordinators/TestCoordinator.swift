//
//  TestCoordinator.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 16/11/2022.
//

import Foundation
import UIKit

class TestCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController!

    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    func start() {
        let testViewController = TestViewController()


        presenter.pushViewController(testViewController, animated: true)
    }


}
