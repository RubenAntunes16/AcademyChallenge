//
//  MainViewCoordinator.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 26/09/2022.
//

import UIKit

class MainViewCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var mainViewController: MainViewController?
    private var emojiList: [Emoji]
    
    init(presenter: UINavigationController, emojiList: [Emoji]){
        self.presenter = presenter
        self.emojiList = emojiList
    }
    
    // THIS THE ABSTRACT FUNCTION FROM COORDINATOR INTERFACE
    func start() {
        
        // CREATE THE VIEW CONTROLLER TO PRESENT
        let mainViewController = MainViewController()
        mainViewController.title = "Main Page"
        mainViewController.emojisList = emojiList
        // PUSH THE NEW VIEW CONTROLLER SO IT CAN BE PRESENT
        presenter.pushViewController(mainViewController, animated: true)
        
        self.mainViewController = mainViewController
    }
}
