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
    
    var viewModel: MainViewModel?
//    private var emojiList: EmojiStorage
//    private var emojiList: [Emoji]
    
    init(presenter: UINavigationController){
        self.presenter = presenter
//        emojiList = emojisList
    }
    
    func start() {
        let emojisListViewController = EmojisListViewController()
        
        emojisListViewController.title = "Emojis List"
        
        let viewModel = EmojiViewModel()
        
        viewModel.emojiService = emojiSource
        
        emojisListViewController.viewModel = viewModel
        
        presenter.pushViewController(emojisListViewController, animated: true)
        
        self.emojisListViewController = emojisListViewController
    }
}
