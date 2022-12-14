//
//  AppleReposCoordinator.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 26/09/2022.
//

import UIKit

class AppleReposCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var appleReposViewController: AppleReposViewController?
    
    init(presenter: UINavigationController){
        self.presenter = presenter
    }
    
    func start() {
        let appleReposViewController = AppleReposViewController()
        
        presenter.pushViewController(appleReposViewController, animated: true)
        
        self.appleReposViewController = appleReposViewController
    }
}
