//
//  AppleReposViewModel.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 27/10/2022.
//

import Foundation
import RxSwift

class AppleReposViewModel {

    var appleReposService: AppleReposService?
    var appleReposList: [AppleRepos] = []
    var isEnd = Wrapper(false)

    var page: Int = 0

    let size = Constants.AppleRepos.perPage

    let disposeBag = DisposeBag()

    private var appleRepos: PublishSubject<[AppleRepos]> = PublishSubject()
    var appleReposResult: Observable<[AppleRepos]> { appleRepos.asObservable() }

//    func getAppleRepos() {
//        self.page += 1
//        self.appleReposService?
//            .getAppleRepos(page: self.page,
//                           size: size, { (result: Result<[AppleRepos], Error>) in
//            switch result {
//            case .success(let success):
//                self.appleReposList.value?.append(contentsOf: success)
//
//                if success.count < Constants.AppleRepos.perPage {
//                    self.isEnd.value = true
//                }
//
//            case .failure(let failure):
//                print("[PREFETCH] Error : \(failure)")
//            }
//        })
//    }

    func callGetReposObservable() {
        guard let appleReposService = appleReposService else {
            return
        }

        self.page += 1

        appleReposService.getAppleRepos(page: page, size: size)
            .subscribe(onSuccess: { [weak self] result in
                guard let self = self else { return }
                self.appleReposList.append(contentsOf: result)
                if result.count < Constants.AppleRepos.perPage {
                    self.isEnd.value = true
                }
                self.appleRepos.onNext(self.appleReposList)
            })
            .disposed(by: disposeBag)
    }
}
