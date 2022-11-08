//
//  AvatarList.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 26/09/2022.
//

import UIKit

class AvatarListCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var avatarListViewController: AvatarListViewController?
    private let avatarService: LiveAvatarService

    init(presenter: UINavigationController, avatarService: LiveAvatarService) {
        self.presenter = presenter
        self.avatarService = avatarService
    }

    func start() {
        let avatarListViewController = AvatarListViewController()
        avatarListViewController.title = "Avatar List"

        let viewModel = AvatarViewModel()

        viewModel.avatarService = avatarService

        avatarListViewController.viewModel = viewModel

        presenter.pushViewController(avatarListViewController, animated: true)

        self.avatarListViewController = avatarListViewController
    }
}
