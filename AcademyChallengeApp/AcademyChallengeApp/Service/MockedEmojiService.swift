//
//  MockedEmojiService.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 06/10/2022.
//

import Foundation

class MockedEmojiService : EmojiService{
    
    private var emojiMocked: EmojiMocked = .init()
    
//    typealias T = [Emoji]
    func getEmojisList(_ resultHandler: @escaping (Result<[Emoji], Error>) -> Void){
        // METHOD IN EMOJI API
//        switch result{
//        case .success(let success):
////                    print("Success: \(success.emojis)")
//            resultHandler(.success(success.emojis))
//        case .failure(let failure):
//            print("Failure: \(failure)")
//            resultHandler(.failure(failure))
//        }
        resultHandler(.success(emojiMocked.mockedEmojis))
    }
}
