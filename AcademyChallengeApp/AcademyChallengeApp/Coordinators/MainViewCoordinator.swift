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
    
    init(presenter: UINavigationController){
        self.presenter = presenter
    }
    
    // THIS THE ABSTRACT FUNCTION FROM COORDINATOR INTERFACE
    func start() {
        
        // CREATE THE VIEW CONTROLLER TO PRESENT
        let mainViewController = MainViewController()
        // PUSH THE NEW VIEW CONTROLLER SO IT CAN BE PRESENT
        presenter.pushViewController(mainViewController, animated: true)
        
        self.mainViewController = mainViewController
    }
}
