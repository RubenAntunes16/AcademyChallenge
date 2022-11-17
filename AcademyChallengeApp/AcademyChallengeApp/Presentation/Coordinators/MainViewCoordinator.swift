//
//  MainViewCoordinator.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 26/09/2022.
//

import UIKit

protocol MainViewDelegate: AnyObject {
    func navigateToEmoji()
    func navigateToAvatar()
    func navigateToAppleRepos()
}

protocol BackMainDelegate: AnyObject {
    func back()
}

class MainViewCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []

    private let presenter: UINavigationController
    private var mainViewController: MainViewController?
    private var emojis: [Emoji]?
    private let applicationStarter: Application

    init(presenter: UINavigationController, application: Application) {
        self.presenter = presenter
        self.applicationStarter = application
    }

    // THIS THE ABSTRACT FUNCTION FROM COORDINATOR INTERFACE
    func start() {

        // CREATE THE VIEW CONTROLLER TO PRESENT
        let mainViewController = MainViewController()
        mainViewController.title = "Main Page"

        mainViewController.delegate = self

        let viewModel = MainViewModel(application: applicationStarter)

        viewModel.application.emojiService = applicationStarter.emojiService

        viewModel.application.avatarService = applicationStarter.avatarService

        mainViewController.viewModel = viewModel

        presenter.pushViewController(mainViewController, animated: true)

        self.mainViewController = mainViewController
    }
}

extension MainViewCoordinator: MainViewDelegate {
    func navigateToEmoji() {
        let emojiCoordinator = EmojisListCoordinator(presenter: presenter,
                                                     emojiService: applicationStarter.emojiService)
        emojiCoordinator.delegate = self
        childCoordinators.append(emojiCoordinator)
        emojiCoordinator.start()
    }

    func navigateToAvatar() {
        let avatarCoordinator = AvatarListCoordinator(presenter: presenter,
                                                      avatarService: applicationStarter.avatarService)
        avatarCoordinator.delegate = self
        childCoordinators.append(avatarCoordinator)
        avatarCoordinator.start()
    }

    func navigateToAppleRepos() {
        let appleReposCoordinator = AppleReposCoordinator(presenter: presenter,
                                                          appleReposService: applicationStarter.appleReposService)
        appleReposCoordinator.delegate = self
        childCoordinators.append(appleReposCoordinator)
        appleReposCoordinator.start()
    }
}

extension MainViewCoordinator: BackMainDelegate {
    func back() {
        childCoordinators.removeLast()
    }
}
