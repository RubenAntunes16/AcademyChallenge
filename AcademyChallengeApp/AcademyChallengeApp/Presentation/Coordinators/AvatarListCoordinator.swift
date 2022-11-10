//
//  AvatarList.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 26/09/2022.
//

import UIKit

class AvatarListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    private let presenter: UINavigationController
    private var avatarListViewController: AvatarListViewController?
    private let avatarService: LiveAvatarService
    weak var delegate: BackMainDelegate?

    init(presenter: UINavigationController, avatarService: LiveAvatarService) {
        self.presenter = presenter
        self.avatarService = avatarService
    }

    func start() {
        let avatarListViewController = AvatarListViewController()
        avatarListViewController.title = "Avatar List"

        avatarListViewController.delegate = self

        let viewModel = AvatarViewModel()

        viewModel.avatarService = avatarService

        avatarListViewController.viewModel = viewModel

        presenter.pushViewController(avatarListViewController, animated: true)

        self.avatarListViewController = avatarListViewController
    }
}

extension AvatarListCoordinator: BackMainDelegate {
    func back() {
        self.delegate?.back()
    }
}

protocol AvatarListCoordinatorDelegate {
    func navigateToAvatar()
}
