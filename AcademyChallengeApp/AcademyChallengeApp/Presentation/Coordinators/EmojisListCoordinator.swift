//
//  EmojisListCoordinator.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 23/09/2022.
//

import Foundation
import UIKit

class EmojisListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var delegate: BackMainDelegate?
    private let presenter: UINavigationController

    var viewModel: EmojiViewModel?
    private let emojiService: EmojiService?
//    private var emojiList: EmojiStorage
//    private var emojiList: [Emoji]

    init(presenter: UINavigationController, emojiService: EmojiService) {
        self.presenter = presenter
        self.emojiService = emojiService
//        emojiList = emojisList
    }

    func start() {
        let emojisListViewController: EmojisListViewController = EmojisListViewController()

        emojisListViewController.title = "Emojis List"

        emojisListViewController.delegate = self

        let viewModel = EmojiViewModel()

        viewModel.emojiService = emojiService

        emojisListViewController.viewModel = viewModel

        presenter.pushViewController(emojisListViewController, animated: true)
    }
}

extension EmojisListCoordinator: BackMainDelegate {
    func back() {
        self.delegate?.back()
    }
}
