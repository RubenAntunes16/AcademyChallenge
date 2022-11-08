//
//  AppleReposCoordinator.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 26/09/2022.
//

import UIKit

class AppleReposCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var appleReposViewController: AppleReposViewController?
    private let appleReposService: AppleReposService

    init(presenter: UINavigationController, appleReposService: AppleReposService) {
        self.presenter = presenter
        self.appleReposService = appleReposService
    }

    func start() {
        let appleReposViewController = AppleReposViewController()

        appleReposViewController.title = "Apple Repos"

        let viewModel = AppleReposViewModel()

        viewModel.appleReposService = appleReposService

        appleReposViewController.viewModel = viewModel

        presenter.pushViewController(appleReposViewController, animated: true)

        self.appleReposViewController = appleReposViewController
    }
}
