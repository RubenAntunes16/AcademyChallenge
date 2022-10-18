//
//  AppleReposViewController.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 26/09/2022.
//

import UIKit

class AppleReposViewController: UIViewController {
    
    var appleReposService: LiveAppleReposService?
    
    var appleReposList: [AppleRepos] = []
    
//    init(){
//
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented.")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .purple
        appleReposService?.getAppleRepos({ (result: Result<[AppleRepos], Error>) in
            switch result {
            case .success(let success):
                self.appleReposList = success
            case .failure(let failure):
                print("[APPLE REPOS] Error to get List: \(failure)")
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}
