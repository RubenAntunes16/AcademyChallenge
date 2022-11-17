//
//  EmojisListCoordinator.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 23/09/2022.
//

import Foundation
import UIKit

protocol TestDelegate: AnyObject {
    func navigateToTest()
}

class EmojisListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var delegate: BackMainDelegate?
    private let presenter: UINavigationController
    private var emojisListViewController: EmojisListViewController?

    var viewModel: EmojiViewModel?
    private let emojiService: EmojiService
//    private var emojiList: EmojiStorage
//    private var emojiList: [Emoji]

    init(presenter: UINavigationController, emojiService: EmojiService) {
        self.presenter = presenter
        self.emojiService = emojiService
//        emojiList = emojisList
    }

    func start() {
        let emojisListViewController = EmojisListViewController()

        emojisListViewController.title = "Emojis List"

        emojisListViewController.delegate = self

        let viewModel = EmojiViewModel()

        viewModel.emojiService = emojiService

        emojisListViewController.viewModel = viewModel

        presenter.pushViewController(emojisListViewController, animated: true)

        self.emojisListViewController = emojisListViewController
    }
}

extension EmojisListCoordinator: BackMainDelegate {
    func back() {
        self.delegate?.back()
    }
}
