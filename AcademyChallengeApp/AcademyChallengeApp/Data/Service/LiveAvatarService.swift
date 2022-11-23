//
//  AvatarService.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 12/10/2022.
//

import UIKit
import CoreData
import RxSwift

class LiveAvatarService: ReactiveCompatible {

    var networkManager: NetworkManager = .init()
    let persistence: AvatarPersistence
    let disposeBag: DisposeBag = DisposeBag()

    init(persistentContainer: NSPersistentContainer) {
        self.persistence = .init(persistentContainer: persistentContainer)
    }

    func fetchAvatarList() -> Single<[Avatar]> {

        return persistence.fetch()
    }

//    func getAvatar(searchText: String, _ resultHandler: @escaping (Result<Avatar, Error>) -> Void) {
//
//        persistence.verifyAvatarExist(searchText: searchText) { ( result: Result<[Avatar], Error>) in
//            switch result {
//            case .success(let success):
//                if success.count != 0 {
//
//                    guard let avatarFound = success.first else { return }
//
//                    resultHandler(.success(avatarFound))
//                } else {
//                    // GET THE AVATAR FROM API
//                    self.networkManager.executeNetworkCall(
//                        AvatarAPI.getAvatars(searchText)) { (result: Result<Avatar, Error>) in
//                        switch result {
//                        case .success(let success):
//                            self.persistence.persist(object: success)
//                            resultHandler(.success(success))
//                        case .failure(let failure):
//                            print("[Avatar Live] Failure: \(failure)")
//                            resultHandler(.failure(failure))
//                        }
//                    }
//                }
//            case .failure(let failure):
//                print("Failure to verify if avatar exists in Core data: \(failure)")
//            }
//        }
//    }

    func getAvatar(searchText: String) -> Observable<Avatar> {

        return persistence.verifyAvatarExist(searchText: searchText)
            .flatMap({ avatar -> Observable<Avatar> in
                guard
                    let avatar = avatar else {
                    return self.networkManager.rx.executeNetworkCall(AvatarAPI.getAvatars(searchText))
                        .do { (result: Avatar) in
                            self.persistence.persist(object: result)
                                .subscribe(onError: { error in
                                    print("Error in persist avatar : \(error)")
                                })
                                .disposed(by: self.disposeBag)
                        }
                        .asObservable()
                }
                return Observable.just(avatar)
            })
    }

    func deleteAvatar(avatarToDelete: Avatar) -> Completable {

        return persistence.delete(avatar: avatarToDelete)
    }
}
