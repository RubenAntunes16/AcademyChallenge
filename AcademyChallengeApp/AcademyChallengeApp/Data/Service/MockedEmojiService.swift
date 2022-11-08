//
//  MockedEmojiService.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 06/10/2022.
//

import Foundation

class MockedEmojiService: EmojiService {

    private var emojiMocked: EmojiMocked = .init()

    func getEmojisList(_ resultHandler: @escaping (Result<[Emoji], Error>) -> Void) {
        // METHOD IN EMOJI API
        resultHandler(.success(emojiMocked.mockedEmojis))
//        resultHandler(.failure())
    }
}
