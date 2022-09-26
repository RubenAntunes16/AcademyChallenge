//
//  ApplicationCoordinator.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 26/09/2022.
//

import UIKit

class ApplicationCoordinator: Coordinator {
    
    // SETUPS IT'S PRESENTATIONS IN THE APP'S WINDOW
    let window: UIWindow
    
    // THE ROOTVIEWCONTROLLER WILL BE THE NAVIGATION CONTROLLER SO WE CAN NAVIGATE BETWEEN THE OTHERS VIEW CONTROLLER
    let rootViewController: UINavigationController
    
    let mainViewCoordinator: MainViewCoordinator
    
    // INITIALIZE THE PROPERTIES
    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        //rootViewController.navigationBar.prefersLargeTitles = true
        
        // Just for testing purposes, when you don't have other view controller to present
//        let emptyViewController = UIViewController()
//        emptyViewController.view.backgroundColor = .cyan
//        rootViewController.pushViewController(emptyViewController, animated: false)
//
        mainViewCoordinator = MainViewCoordinator(presenter: rootViewController)
    }
    
    // THIS FUNCTION WILL PRESENT THE WINDOW WITH ITS ROOTVIEWCONTROLLER
    func start() {
        window.rootViewController = rootViewController
        mainViewCoordinator.start()
        window.makeKeyAndVisible()
    }
}
