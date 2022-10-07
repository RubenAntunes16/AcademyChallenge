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
    
    init(presenter: UINavigationController){
        self.presenter = presenter
//        self.emojis = emojis
//        self.emojisStorage = emojiStorage
//        self.emojisStorage?.delegate = self
    }
    
    // THIS THE ABSTRACT FUNCTION FROM COORDINATOR INTERFACE
    func start() {
        
        // CREATE THE VIEW CONTROLLER TO PRESENT
        let mainViewController = MainViewController()
        mainViewController.title = "Main Page"
        mainViewController.emojiService = emojiSource
//        mainViewController.emojisStorage = emojisStorage
        // PUSH THE NEW VIEW CONTROLLER SO IT CAN BE PRESENT
        presenter.pushViewController(mainViewController, animated: true)
        
        self.mainViewController = mainViewController
    }
}

//extension MainViewCoordinator: EmojiStorageDelegate {
//    func emojiListUpdated() {
//        presenter.viewControllers.forEach {
//            ($0 as? EmojiPresenter)?.emojiListUpdated()
//        }
//    }
//}
