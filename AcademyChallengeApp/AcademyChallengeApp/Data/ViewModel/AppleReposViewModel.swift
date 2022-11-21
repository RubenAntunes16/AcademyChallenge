//
//  AppleReposViewModel.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 27/10/2022.
//

import Foundation

class AppleReposViewModel {

    var appleReposService: AppleReposService?
    var appleReposList: Wrapper<[AppleRepos]?> = Wrapper([])
    var isEnd = Wrapper(false)

    var page: Int = 0

    let size = Constants.AppleRepos.perPage

    func getAppleRepos() {
        self.page += 1
        self.appleReposService?
            .getAppleRepos(page: self.page,
                           size: size, { [weak self] (result: Result<[AppleRepos], Error>) in
                guard let self = self else { return }
            switch result {
            case .success(let success):
                self.appleReposList.value?.append(contentsOf: success)

                if success.count < Constants.AppleRepos.perPage {
                    self.isEnd.value = true
                }

            case .failure(let failure):
                print("[PREFETCH] Error : \(failure)")
            }
        })
    }
}
