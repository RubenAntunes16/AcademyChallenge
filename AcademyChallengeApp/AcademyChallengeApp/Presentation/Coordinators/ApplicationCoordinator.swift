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
        rootViewController.navigationBar.tintColor = .appColor(name: .primary)
        rootViewController.navigationBar.prefersLargeTitles = true

        let application: Application = .init()
        mainViewCoordinator = MainViewCoordinator(presenter: rootViewController, application: application)
    }

    // THIS FUNCTION WILL PRESENT THE WINDOW WITH ITS ROOTVIEWCONTROLLER
    func start() {
        window.rootViewController = rootViewController
        mainViewCoordinator.start()
        window.makeKeyAndVisible()
    }
}
