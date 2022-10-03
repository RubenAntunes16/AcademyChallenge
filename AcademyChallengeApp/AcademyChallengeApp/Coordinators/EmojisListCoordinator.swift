//
//  EmojisListCoordinator.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 23/09/2022.
//

import Foundation
import UIKit

class EmojisListCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var emojisListViewController: EmojisListViewController?
//    private var emojiList: EmojiStorage
    private var emojiList: [Emoji]
    
    init(presenter: UINavigationController, emojisList: [Emoji]){
        self.presenter = presenter
        emojiList = emojisList
    }
    
    func start() {
        let emojisListViewController = EmojisListViewController()
        
        emojisListViewController.emojisList = emojiList
        
        presenter.pushViewController(emojisListViewController, animated: true)
        
        self.emojisListViewController = emojisListViewController
    }
}
