//
//  MockedEmojiService.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 06/10/2022.
//

import Foundation
import RxSwift

class MockedEmojiService: EmojiService {

    private var emojiMocked: EmojiMocked = .init()

    func getEmojisList() -> Single<[Emoji]> {
        return Single<[Emoji]>.create(subscribe: { [weak self] single in
            let disposable: Disposable = Disposables.create()
            guard let self = self else { return disposable }
            single(.success(self.emojiMocked.mockedEmojis))
            return disposable
        })
    }

    func getEmojisList(_ resultHandler: @escaping (Result<[Emoji], Error>) -> Void) {
        // METHOD IN EMOJI API
        resultHandler(.success(emojiMocked.mockedEmojis))
    }
}
