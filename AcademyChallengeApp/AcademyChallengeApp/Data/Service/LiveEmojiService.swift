//
//  EmojiService.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 04/10/2022.
//

import Foundation
import CoreData

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
            persistence.persist(name: emoji.name, urlImage: emoji.urlImage.absoluteString)
        }
    }

    func getEmojisList(_ resultHandler: @escaping (Result<[Emoji], Error>) -> Void) {
        var fetchedEmojis: [Emoji] = []

        persistence.fetch { (result: [Emoji]) in
            fetchedEmojis = result
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
                    self.persistEmojis(emojis: success.emojis)
                    resultHandler(.success(success.emojis))
                case .failure(let failure):
                    print("Failure: \(failure)")
                    resultHandler(.failure(failure))
                }
            }
        }
    }
}
