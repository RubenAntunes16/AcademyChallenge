//
//  MockedAppleReposService.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 19/10/2022.
//

import Foundation

import RxSwift

class MockedAppleReposService: AppleReposService {

    private var reposMocked: AppleReposMock = .init()
    private let mockedRepos: [AppleRepos]

    init() {
        mockedRepos = reposMocked.mockedAppleRepos
    }

//    func getAppleRepos(page: Int, size: Int, _ resultHandler: @escaping (Result<[AppleRepos], Error>) -> Void) {
//        var repos: [AppleRepos] = []
//        let endIndex = size * page
//        let startIndex = endIndex - size
//
//        if endIndex <= mockedRepos.count {
//            repos = [AppleRepos](mockedRepos[startIndex...endIndex-1])
//        }

//        for i in startIndex...endIndex - 1{
//            if i < mockedRepos.count {
//                repos.append(mockedRepos[i])
//            }
//
//        }
//
//        resultHandler(.success(repos))
//
//    }

    func getAppleRepos(page: Int, size: Int) -> Observable<[AppleRepos]> {

        return Observable<[AppleRepos]>.create { observer in
            var repos: [AppleRepos] = []
            let endIndex = size * page
            let startIndex = endIndex - size

            for index in startIndex...endIndex - 1 {
                if index < self.mockedRepos.count {
                    repos.append(self.mockedRepos[index])
                }
            }

            observer.onNext(repos)

            return Disposables.create()
        }

    }

}
