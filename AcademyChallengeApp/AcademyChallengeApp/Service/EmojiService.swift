//
//  EmojiService.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 04/10/2022.
//

import Foundation

class EmojiService {
    
    private var networkManager: NetworkManager = .init()
    
    func getEmojisList(_ resultHandler: @escaping (EmojiAPICallResult) -> Void){
        // METHOD IN EMOJI API
        networkManager.executeNetworkCall(EmojiAPI.getEmojis) { (result: Result<EmojiAPICallResult, Error>) in
            switch result{
            case .success(let success):
                //print("Success: \(success)")
                resultHandler(success)
            case .failure(let failure):
                print("Failure: \(failure)")
            }
        }
    }
    
    func getRandomEmojiUrl(_ resultUrl: @escaping (URL) -> Void) {
        // fetch emojis and return a random emoji
        getEmojisList { (result: EmojiAPICallResult) in
            
            guard let randomUrl = result.emojis.randomElement()?.urlImage else { return }
            
            resultUrl(randomUrl)
        }
    }
}
