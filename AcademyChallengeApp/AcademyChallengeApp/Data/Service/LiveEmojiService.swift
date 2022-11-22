//
//  EmojiService.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 04/10/2022.
//

import Foundation
import CoreData
import RxSwift

class LiveEmojiService: EmojiService {

    private var networkManager: NetworkManager = .init()
    private let persistentContainer: NSPersistentContainer
    private var persistence: EmojiPersistence {
        return .init(persistentContainer: persistentContainer)
    }

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    let disposeBag: DisposeBag = DisposeBag()

    private func persistEmojis(emojis: [Emoji]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            emojis.forEach { emoji in
                self.persistence.persist(object: emoji)
                    .subscribe(onError: { error in
                        print("Error in persist emoji : \(error)")
                    })
                    .disposed(by: self.disposeBag)
            }
        }
    }

    func getEmojisList() -> Single<[Emoji]> {

        return persistence.fetch()
            .do(onError: { error in
                print("[LiveEmojiService] Error to get fetch: \(error)")
            })
            .flatMap({ fetchedEmojis in
                if fetchedEmojis.isEmpty {
                    // SUBSCRIBE DESTROI OS OBSERVABLES
                    // SUBSCRIBE APENAS DEVE HAVER NO FIM
                    // DO() SÓ ESTAMOS A ACRESCENTAR UM EVENTO (SIDE EFFECT) AO OBSERVABLE
                    // DO() NÃO TERMINA O FLUXO DO OBSERVABLE
                    return self.networkManager.rxExecuteNetworkCall(EmojiAPI.getEmojis)
                        .map { (emojisResult: EmojiAPICallResult) in
                            self.persistEmojis(emojis: emojisResult.emojis)
                            return emojisResult.emojis
                        }
                }
                return Single<[Emoji]>.just(fetchedEmojis)
            })
    }
}

extension Reactive where Base: LiveEmojiService {

    func getEmojiList() -> Single<[Emoji]> {

        return base.getEmojisList()
    }
}
