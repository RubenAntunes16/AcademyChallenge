//
//  EmojiService.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 04/10/2022.
//

import Foundation

class LiveEmojiService : EmojiService{
    
    private var networkManager: NetworkManager = .init()
    
//    typealias T = EmojiAPICallResult
    
    func getEmojisList(_ resultHandler: @escaping (Result<[Emoji], Error>) -> Void){
        // METHOD IN EMOJI API
            networkManager.executeNetworkCall(EmojiAPI.getEmojis) { (result: Result<EmojiAPICallResult, Error>) in
                switch result{
                case .success(let success):
//                    print("Success: \(success.emojis)")
                    resultHandler(.success(success.emojis))
                case .failure(let failure):
                    print("Failure: \(failure)")
                    resultHandler(.failure(failure))
                }
            }
    }
}


