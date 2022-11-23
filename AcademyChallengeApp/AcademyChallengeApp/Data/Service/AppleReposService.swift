//
//  AppleReposService.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 19/10/2022.
//

import Foundation
import RxSwift

protocol AppleReposService {

    func getAppleRepos(page: Int, size: Int, _ resultHandler: @escaping (Result<[AppleRepos], Error>) -> Void)

    func getAppleRepos(page: Int, size: Int) -> Single<[AppleRepos]>
}
