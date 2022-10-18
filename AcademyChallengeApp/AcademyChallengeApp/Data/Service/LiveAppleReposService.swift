//
//  LiveAppleReposService.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 17/10/2022.
//

import Foundation

class LiveAppleReposService {
    
    private let networkManager: NetworkManager = .init()
    
    func getAppleRepos(_ resultHandler: @escaping (Result<[AppleRepos],Error>) -> Void){
        networkManager.executeNetworkCall(AppleReposAPI.getAppleRepos) { (result: Result<[AppleRepos], Error>) in
            switch result {
            case .success(let success):
                resultHandler(.success(success))
            case .failure(let failure):
                resultHandler(.failure(failure))
            }
        }
    }
}
