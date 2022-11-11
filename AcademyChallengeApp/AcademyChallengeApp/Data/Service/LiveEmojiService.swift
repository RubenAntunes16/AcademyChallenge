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

    private func persistEmojis(emojis: [Emoji]) {
        emojis.forEach { emoji in
            persistence.persist(object: emoji)
        }
    }

    func getEmojisList(_ resultHandler: @escaping (Result<[Emoji], Error>) -> Void) {
        var fetchedEmojis: [Emoji] = []

        persistence.fetch { (result: Result<[Emoji], Error>) in
            switch result {
            case .success(let success):
                fetchedEmojis = success
            case .failure(let failure):
                resultHandler(.failure(failure))
            }

        }

        if !fetchedEmojis.isEmpty {

            resultHandler(.success(fetchedEmojis))

        } else {
            // METHOD IN EMOJI API
            networkManager.executeNetworkCall(
                EmojiAPI.getEmojis) { [weak self] (result: Result<EmojiAPICallResult, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let success):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }

                        self.persistEmojis(emojis: success.emojis)
                    }
                    resultHandler(.success(success.emojis))
                case .failure(let failure):
                    print("[Emoji Live] Failure: \(failure)")
                    resultHandler(.failure(failure))
                }
            }
        }
    }

    func rxGetEmojisList() -> Single<[Emoji]> {
        // SUBSCRIBE DESTROI OS OBSERVABLES
        // SUBSCRIBE APENAS DEVE HAVER NO FIM
        // DO() SÓ ESTAMOS A ACRESCENTAR UM EVENTO (SIDE EFFECT) AO OBSERVABLE
        // DO() NÃO TERMINA O FLUXO DO OBSERVABLE
        return networkManager.rxExecuteNetworkCall(EmojiAPI.getEmojis)
            .map { (emojisResult: EmojiAPICallResult) in
                    return emojisResult.emojis
                }

    }
}
