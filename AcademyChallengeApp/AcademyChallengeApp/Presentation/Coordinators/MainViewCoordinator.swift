//
//  MainViewCoordinator.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 26/09/2022.
//

import UIKit

class MainViewCoordinator: Coordinator {

//    var emojisStorage: EmojiStorage?

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

        let viewModel = MainViewModel(application: applicationStarter)

        viewModel.application.emojiSource = applicationStarter.emojiSource

        viewModel.application.avatarService = applicationStarter.avatarService

        mainViewController.viewModel = viewModel

        presenter.pushViewController(mainViewController, animated: true)

        self.mainViewController = mainViewController
    }
}
