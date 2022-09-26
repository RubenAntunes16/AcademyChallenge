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
    
    init(presenter: UINavigationController){
        self.presenter = presenter
    }
    
    func start() {
        let emojisListViewController = EmojisListViewController()
        
        presenter.pushViewController(emojisListViewController, animated: true)
        
        self.emojisListViewController = emojisListViewController
    }
}
