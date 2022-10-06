//
//  EmojiService.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 04/10/2022.
//

import Foundation

class EmojiService{
        
    private var networkManager: NetworkManager = .init()
    private var emojis: [Emoji]?
    
    init(emojis: [Emoji]?) {
        self.emojis = emojis
    }
    
    func getEmojisList(_ resultHandler: @escaping (EmojiAPICallResult) -> Void){
        
        if emojis == nil {
            networkManager.executeNetworkCall(EmojiAPI.getEmojis) { (result: Result<EmojiAPICallResult, Error>) in
                switch result{
                case .success(let success):
                    //print("Success: \(success)")
                    resultHandler(success)
                case .failure(let failure):
                    print("Failure: \(failure)")
                }
            }
        }else {
            resultHandler(emojis)
        }
        // METHOD IN EMOJI API
        
    }
    
    func getRandomEmojiUrl(_ resultUrl: @escaping (URL) -> Void) {
        // fetch emojis and return a random emoji
        if emojis == nil {
            getEmojisList { (result: EmojiAPICallResult) in
                
                guard let randomUrl = result.emojis.randomElement()?.urlImage else { return }
                
                resultUrl(randomUrl)
            }
        }else{
            guard let randomUrl = emojis?.randomElement()?.urlImage else { return }
            
            resultUrl(randomUrl)
        }
    }
}

protocol EmojiService {
    func getEmojisList()
    func getRandomList()
}
