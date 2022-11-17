//
//  LiveAppleReposService.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 17/10/2022.
//

import Foundation
import RxSwift

class LiveAppleReposService: AppleReposService {

    private let networkManager: NetworkManager = .init()

//    func getAppleRepos(page: Int, size: Int, _ resultHandler: @escaping (Result<[AppleRepos], Error>) -> Void) {
//        networkManager.executeNetworkCall(
//            AppleReposAPI.getAppleRepos(perPage: size, page: page)) { (result: Result<[AppleRepos], Error>) in
//            switch result {
//            case .success(let success):
//                resultHandler(.success(success))
//            case .failure(let failure):
//                resultHandler(.failure(failure))
//            }
//        }
//    }

    func getAppleRepos(page: Int, size: Int) -> Single<[AppleRepos]> {
        return networkManager
            .rxExecuteNetworkCall(AppleReposAPI.getAppleRepos(perPage: size, page: page))
    }
}
