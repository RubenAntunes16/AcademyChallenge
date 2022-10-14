//
//  AvatarList.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 26/09/2022.
//

import UIKit

class AvatarListCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var avatarListViewController: AvatarListViewController?
    
    init(presenter: UINavigationController){
        self.presenter = presenter
    }
    
    func start() {
        let avatarListViewController = AvatarListViewController()
        avatarListViewController.title = "Avatar List"
        
        avatarListViewController.avatarService = avatarService
        
        presenter.pushViewController(avatarListViewController, animated: true)
        
        self.avatarListViewController = avatarListViewController
    }
}
